// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZKVerifier {
    function verifyProof(bytes memory proof, bytes32 input) public pure returns (bool) {
        return true; 
    }

    function verifyOffChainData(bytes memory data) external pure returns (bool) {
        return true;
    }
}
