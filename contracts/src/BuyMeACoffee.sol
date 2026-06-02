// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "./interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error BuyMeACoffee__NotEnoughETH();
error BuyMeACoffee__NotOwner();
error BuyMeACoffee__MessageTooLong();
error BuyMeACoffee__WithdrawFailed();

contract BuyMeACoffee {
    using PriceConverter for uint256;

    struct Donor {
        address donor;
        string message;
        uint256 timestamp;
        uint256 amount;
    }

    uint256 public constant MINIMUM_USD = 3e18;
    AggregatorV3Interface private immutable i_priceFeed;
    address private immutable i_owner;
    Donor[] private s_donors;

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert BuyMeACoffee__NotOwner();
        _;
    }

    constructor(address priceFeed) {
        i_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    function fund(string memory message) public payable {
        if (msg.value.getConversionRate(i_priceFeed) < MINIMUM_USD) {
            revert BuyMeACoffee__NotEnoughETH();
        }
        if (bytes(message).length > 200) {
            revert BuyMeACoffee__MessageTooLong();
        }

        s_donors.push(Donor({donor: msg.sender, message: message, timestamp: block.timestamp, amount: msg.value}));
    }

    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: address(this).balance}("");
        if (!success) revert BuyMeACoffee__WithdrawFailed();
    }

    function getDonor(uint256 index) public view returns (Donor memory) {
        return s_donors[index];
    }

    function getDonors() public view returns (Donor[] memory) {
        return s_donors;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getNumberOfDonors() public view returns (uint256) {
        return s_donors.length;
    }

    receive() external payable {
        fund("");
    }

    fallback() external payable {
        fund("");
    }
}
