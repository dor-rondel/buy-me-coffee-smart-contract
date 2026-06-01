// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "./interfaces/AggregatorV3Interface.sol";

error PriceConverter__NegativePrice();

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // We only need the price (answer)
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        if (answer < 0) revert PriceConverter__NegativePrice();
        // ETH/USD rate is in 8 decimals, we convert it to 18 decimals to match Wei
        // casting to 'uint256' is safe because we check for negative values above
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(answer) * 1e10;
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
