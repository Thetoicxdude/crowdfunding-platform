// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ZKVerifier.sol";

contract AITracker {
    struct UserActivity {
        uint256[] projectInteractions;
        uint256[] investments;
        uint256 totalAmountInvested;
        uint256 lastInteractionTime;
    }

    mapping(address => UserActivity) public userActivities;
    ZKVerifier public zkVerifier;

    event ActivityLogged(address indexed user, string activityType, uint256 projectId, uint256 amount);

    constructor(ZKVerifier _zkVerifier) {
        zkVerifier = _zkVerifier;
    }

    function logInteraction(address user, uint256 projectId) external {
        userActivities[user].projectInteractions.push(projectId);
        userActivities[user].lastInteractionTime = block.timestamp;

        emit ActivityLogged(user, "Interaction", projectId, 0);
    }

    function logInvestment(address user, uint256 projectId, uint256 amount) external {
        userActivities[user].investments.push(projectId);
        userActivities[user].totalAmountInvested += amount;
        userActivities[user].lastInteractionTime = block.timestamp;

        emit ActivityLogged(user, "Investment", projectId, amount);
    }

    function getUserActivityData(address user) external view returns (UserActivity memory) {
        return userActivities[user];
    }

    function verifyAIRecommendation(bytes memory proof, bytes32 input) external view returns (bool) {
        return zkVerifier.verifyProof(proof, input);
    }
}

