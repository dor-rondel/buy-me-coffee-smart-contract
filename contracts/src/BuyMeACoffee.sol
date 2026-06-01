// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "./interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error BuyMeACoffee__NotEnoughETH();

contract BuyMeACoffee {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 3e18;
    AggregatorV3Interface private immutable i_priceFeed;

    constructor(address priceFeed) {
        i_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        if (msg.value.getConversionRate(i_priceFeed) < MINIMUM_USD) {
            revert BuyMeACoffee__NotEnoughETH();
        }
    }
}
