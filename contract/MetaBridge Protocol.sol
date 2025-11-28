// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MetaBridge Protocol
 * @dev A lightweight cross-chain escrow and asset-locking demonstration contract.
 */
contract Project {
    address public owner;

    struct BridgeRequest {
        address requester;
        uint256 amount;
        bool completed;
    }

    mapping(uint256 => BridgeRequest) public requests;
    uint256 public requestCount;

    event AssetLocked(uint256 requestId, address indexed user, uint256 amount);
    event AssetReleased(uint256 requestId, address indexed user, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Lock assets into the bridge.
     */
    function lockAssets() external payable returns (uint256) {
        require(msg.value > 0, "Must lock value");

        requestCount++;
        requests[requestCount] = BridgeRequest(msg.sender, msg.value, false);

        emit AssetLocked(requestCount, msg.sender, msg.value);
        return requestCount;
    }

    /**
     * @notice Release locked assets back to requester (simulating cross-chain validation).
     */
    function releaseAssets(uint256 requestId) external {
        require(msg.sender == owner, "Only owner can release");
        BridgeRequest storage req = requests[requestId];
        require(!req.completed, "Already completed");

        req.completed = true;
        payable(req.requester).transfer(req.amount);

        emit AssetReleased(requestId, req.requester, req.amount);
    }

    /**
     * @notice View the details of a specific bridge request.
     */
    function getRequest(uint256 requestId)
        external
        view
        returns (address requester, uint256 amount, bool completed)
    {
        BridgeRequest memory req = requests[requestId];
        return (req.requester, req.amount, req.completed);
    }
}

