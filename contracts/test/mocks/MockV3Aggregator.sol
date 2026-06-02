// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title MockV3Aggregator
 * @notice Simplified Mock for testing Chainlink Data Feeds locally.
 */
contract MockV3Aggregator {
    uint8 public decimals;
    int256 public latestAnswer;
    uint256 public latestTimestamp;
    uint256 public latestRound;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        decimals = _decimals;
        updateAnswer(_initialAnswer);
    }

    function updateAnswer(int256 _answer) public {
        latestAnswer = _answer;
        latestTimestamp = block.timestamp;
        latestRound++;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            // forge-lint: disable-next-line(unsafe-typecast)
            uint80(latestRound),
            latestAnswer,
            latestTimestamp,
            latestTimestamp,
            // forge-lint: disable-next-line(unsafe-typecast)
            uint80(latestRound)
        );
    }

    function description() external pure returns (string memory) {
        return "v0.8/tests/MockV3Aggregator.sol";
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        )
    {
        return (
            _roundId,
            latestAnswer,
            latestTimestamp,
            latestTimestamp,
            _roundId
        );
    }
}
