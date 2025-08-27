// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @notice Minimal Chainlink-like price feed mock
contract MockV3Aggregator {
    uint8 public decimals;
    int256 private _latestAnswer;
    uint80 private _roundId;
    uint256 private _updatedAt;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        decimals = _decimals;
        _latestAnswer = _initialAnswer;
        _roundId = 1;
        _updatedAt = block.timestamp;
    }

    /// @notice Update the mock price manually
    function updateAnswer(int256 _answer) external {
        _latestAnswer = _answer;
        _roundId++;
        _updatedAt = block.timestamp;
    }

    /// @notice Mimics Chainlink's latestRoundData
    function latestRoundData()
        external
        view
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (_roundId, _latestAnswer, _updatedAt, _updatedAt, _roundId);
    }
}
