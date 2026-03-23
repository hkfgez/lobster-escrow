// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title LobsterEscrow - Optimistic A2A Settlement Protocol
 * @dev 引入乐观挑战期 (Optimistic Challenge Period) 与 Slash 机制
 */
contract LobsterEscrow {
    
    enum EscrowState { AwaitingStake, Locked, Delivered, InChallenge, Settled, Refunded }

    struct Escrow {
        address buyer;
        address seller;
        uint256 amount;
        uint256 sellerStake; // 卖方必须质押保证金，防止 API 投毒
        EscrowState state;
        uint256 deliveryTimestamp;
    }

    mapping(uint256 => Escrow) public escrows;
    
    // 挑战期窗口：例如 24 小时 (以秒为单位)
    uint256 public constant CHALLENGE_WINDOW = 86400; 
    // 挑战成功后，挑战者的分润比例 (例如 50%)
    uint256 public constant SLASH_REWARD_BPS = 5000; 

    // 事件监听，用于前端 Explorer 实时抓取
    event DataDelivered(uint256 indexed escrowId, uint256 timestamp);
    event ChallengeInitiated(uint256 indexed escrowId, address challenger);
    event EscrowSlashed(uint256 indexed escrowId, address challenger, uint256 reward);
    event EscrowSettled(uint256 indexed escrowId, uint256 amount);

    /**
     * @dev 卖方 Agent 提交数据/服务后触发
     * 状态从 Locked 变为 Delivered，并开启 24 小时挑战倒计时
     */
    function deliverService(uint256 _escrowId) external {
        Escrow storage escrow = escrows[_escrowId];
        require(msg.sender == escrow.seller, "Only Seller Agent");
        require(escrow.state == EscrowState.Locked, "Invalid state");

        escrow.state = EscrowState.Delivered;
        escrow.deliveryTimestamp = block.timestamp;

        emit DataDelivered(_escrowId, block.timestamp);
    }

    /**
     * @dev 买方 Agent 或 Watchtower 在挑战期内提交欺诈证明
     * 触发状态挂起，等待最终仲裁或 zkML 验证
     */
    function challengeDelivery(uint256 _escrowId, bytes calldata /* fraudProof */) external {
        Escrow storage escrow = escrows[_escrowId];
        require(escrow.state == EscrowState.Delivered, "Not in delivery state");
        require(block.timestamp <= escrow.deliveryTimestamp + CHALLENGE_WINDOW, "Challenge window closed");

        escrow.state = EscrowState.InChallenge;
        
        // 实际主网逻辑会在这里调用 verifyZkMLProof(fraudProof) 或接入 Kleros 仲裁
        
        emit ChallengeInitiated(_escrowId, msg.sender);
    }

    /**
     * @dev 挑战期结束且无人挑战，系统自动/由任何人触发结算
     */
    function executeSettlement(uint256 _escrowId) external {
        Escrow storage escrow = escrows[_escrowId];
        require(escrow.state == EscrowState.Delivered, "Not in delivered state");
        require(block.timestamp > escrow.deliveryTimestamp + CHALLENGE_WINDOW, "Challenge period active");

        escrow.state = EscrowState.Settled;

        // 核心：退还卖方保证金 + 支付买方资金
        uint256 payout = escrow.amount + escrow.sellerStake;
        
        // 此处应接入 OKX Onchain OS 跨链路由实现 Omnichain 转账
        // okxRouter.crossChainTransfer(...)
        
        emit EscrowSettled(_escrowId, payout);
    }

    /**
     * @dev 挑战成功，Slash 卖方保证金！
     */
    function executeSlash(uint256 _escrowId, address _challenger) external {
        Escrow storage escrow = escrows[_escrowId];
        require(escrow.state == EscrowState.InChallenge, "Not in challenge");

        escrow.state = EscrowState.Refunded;

        // 资金清算逻辑：买方拿回本金
        uint256 buyerRefund = escrow.amount;
        
        // 惩罚逻辑：卖方保证金被没收，按比例分给挑战者
        uint256 challengerReward = (escrow.sellerStake * SLASH_REWARD_BPS) / 10000;
        uint256 protocolFee = escrow.sellerStake - challengerReward;

        // 执行转账 (伪代码)
        // transfer(escrow.buyer, buyerRefund);
        // transfer(_challenger, challengerReward);
        // transfer(treasury, protocolFee);

        emit EscrowSlashed(_escrowId, _challenger, challengerReward);
    }
}
