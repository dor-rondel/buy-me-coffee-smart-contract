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

    /// @notice Initializes the contract with a price feed address
    /// @param priceFeed The address of the Chainlink price feed
    constructor(address priceFeed) {
        i_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
    }

    /// @notice Allows a user to donate ETH to the contract
    /// @dev Requires a minimum contribution in USD
    /// @param message A message to include with the donation (max 200 chars)
    function fund(string memory message) public payable {
        if (msg.value.getConversionRate(i_priceFeed) < MINIMUM_USD) {
            revert BuyMeACoffee__NotEnoughETH();
        }
        if (bytes(message).length > 200) {
            revert BuyMeACoffee__MessageTooLong();
        }

        s_donors.push(Donor({donor: msg.sender, message: message, timestamp: block.timestamp, amount: msg.value}));
    }

    /// @notice Allows the owner to withdraw all funds
    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: address(this).balance}("");
        if (!success) revert BuyMeACoffee__WithdrawFailed();
    }

    /// @notice Returns a specific donor by index
    /// @param index The index of the donor to retrieve
    /// @return A Donor struct
    function getDonor(uint256 index) public view returns (Donor memory) {
        return s_donors[index];
    }

    /// @notice Returns all donors
    /// @return An array of all Donor structs
    function getDonors() public view returns (Donor[] memory) {
        return s_donors;
    }

    /// @notice Returns the contract owner
    /// @return The owner's address
    function getOwner() public view returns (address) {
        return i_owner;
    }

    /// @notice Returns the total number of donors
    /// @return The number of donors
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
