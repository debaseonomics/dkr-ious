//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract IOUS {
    using SafeERC20 for IERC20;

    IERC20 debase;
    IERC20 degov;

    uint256 public debaseExchangeRate;
    uint256 public degovExchangeRate;
    uint256 public duration;

    mapping(address => uint256) public debaseDeposited;
    mapping(address => uint256) public degovDeposited;
    mapping(address => uint256) public iouBalance;

    constructor(
        IERC20 debase_,
        IERC20 degov_,
        uint256 duration_,
        uint256 debaseExchangeRate_,
        uint256 degovExchangeRate_
    ) {
        debase = debase_;
        degov = degov_;

        duration = block.timestamp + duration_;
        debaseExchangeRate = debaseExchangeRate_;
        degovExchangeRate = degovExchangeRate_;
    }

    modifier inDuration() {
        require(block.timestamp <= duration, "IOU duration passed");
        _;
    }

    function depositDebase(uint256 amount) public inDuration {
        debaseDeposited[msg.sender] += amount;

        uint256 iouAmount = (amount * debaseExchangeRate) / 1 ether;
        iouBalance[msg.sender] += iouAmount;
    }

    function depositDegov(uint256 amount) public inDuration {
        degovDeposited[msg.sender] += amount;

        uint256 iouAmount = (amount * degovExchangeRate) / 1 ether;
        iouBalance[msg.sender] += iouAmount;
    }
}
