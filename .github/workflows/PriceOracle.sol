// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PriceOracle {
    uint256 public fundingFee;

    function getFundingFee() external view returns (uint256) {
        return fundingFee;
    }

    function setFundingFee(uint256 _newFee) external {
        fundingFee = _newFee;
    }
}
