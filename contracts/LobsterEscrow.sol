// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LobsterEscrow - Agent-to-Agent Programmable Trust Layer
 * @dev Deployed on OKX Onchain OS (X Layer)
 */
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract LobsterEscrow {
    address public arbiterEngine; // The Verification Engine (Claw/TEE Oracle)
    
    enum EscrowState { Draft, Funded, Accepted, Delivered, Settled, Refunded, Slashed }

    struct Order {
        address buyerAgent;
        address sellerAgent;
        address token;
        uint256 budget;
        uint256 stakeAmount; // Seller's skin in the game
        EscrowState state;
        bytes32 verificationRuleHash; // ZK/TEE proof verification hash
    }

    mapping(bytes32 => Order) public escrows;

    modifier onlyArbiter() {
        require(msg.sender == arbiterEngine, "Only Verification Engine can call");
        _;
    }

    constructor() {
        arbiterEngine = msg.sender; // In production, this is the TEE/Oracle address
    }

    // Buyer creates order and locks funds
    function createEscrow(bytes32 _orderId, address _token, uint256 _budget, bytes32 _ruleHash) external {
        require(escrows[_orderId].buyerAgent == address(0), "Order exists");
        IERC20(_token).transferFrom(msg.sender, address(this), _budget);
        
        escrows[_orderId] = Order({
            buyerAgent: msg.sender,
            sellerAgent: address(0),
            token: _token,
            budget: _budget,
            stakeAmount: _budget, // 1:1 Stake required
            state: EscrowState.Funded,
            verificationRuleHash: _ruleHash
        });
    }

    // Seller accepts order and locks stake (The Penalty Path foundation)
    function acceptEscrow(bytes32 _orderId) external {
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Funded, "Invalid state");
        
        IERC20(order.token).transferFrom(msg.sender, address(this), order.stakeAmount);
        order.sellerAgent = msg.sender;
        order.state = EscrowState.Accepted;
    }

    // Happy Path: Verification passes, funds + stake released to Seller
    function settle(bytes32 _orderId, bytes calldata _zkProof) external onlyArbiter {
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Not in Accepted state");
        // ... ZK Proof verification logic would go here ...
        
        order.state = EscrowState.Settled;
        IERC20(order.token).transfer(order.sellerAgent, order.budget + order.stakeAmount);
    }

    // Fail Path: Verification fails gracefully, refund buyer, return stake to seller
    function refund(bytes32 _orderId) external onlyArbiter {
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Not in Accepted state");
        
        order.state = EscrowState.Refunded;
        IERC20(order.token).transfer(order.buyerAgent, order.budget);
        IERC20(order.token).transfer(order.sellerAgent, order.stakeAmount);
    }

    // Penalty Path: Malicious behavior detected, slash seller's stake, give to buyer
    function slash(bytes32 _orderId) external onlyArbiter {
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Not in Accepted state");
        
        order.state = EscrowState.Slashed;
        // Buyer gets their budget back PLUS the seller's stake
        IERC20(order.token).transfer(order.buyerAgent, order.budget + order.stakeAmount);
    }
}
