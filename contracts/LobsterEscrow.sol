// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract LobsterEscrow {
    address public treasuryDAO; // 龙虾协议的国库（收手续费的地方）
    address public teeEnclaveKey; // TEE 硬件隔离环境的公钥
    uint256 public constant PROTOCOL_FEE_BPS = 200; // 协议抽水 2% (200 basis points)
    
    enum EscrowState { Draft, Funded, Accepted, Delivered, Settled, Refunded, Slashed }

    struct Order {
        address buyerAgent;
        address sellerAgent;
        address token;
        uint256 budget;
        uint256 stakeAmount;
        EscrowState state;
    }

    mapping(bytes32 => Order) public escrows;

    constructor(address _teeKey) {
        treasuryDAO = msg.sender;
        teeEnclaveKey = _teeKey; // 部署时绑定 TEE 的公钥，确保结果不可伪造
    }

    // 买家建单
    function createEscrow(bytes32 _orderId, address _token, uint256 _budget) external {
        require(escrows[_orderId].buyerAgent == address(0), "Exists");
        IERC20(_token).transferFrom(msg.sender, address(this), _budget);
        
        escrows[_orderId] = Order({
            buyerAgent: msg.sender,
            sellerAgent: address(0),
            token: _token,
            budget: _budget,
            stakeAmount: _budget, // 要求卖家 1:1 质押
            state: EscrowState.Funded
        });
    }

    // 卖家接单并质押保证金
    function acceptEscrow(bytes32 _orderId) external {
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Funded, "Invalid");
        IERC20(order.token).transferFrom(msg.sender, address(this), order.stakeAmount);
        order.sellerAgent = msg.sender;
        order.state = EscrowState.Accepted;
    }

    // 内部验证 TEE 签名
    function _verifyTEESignature(bytes32 _orderId, string memory _status, uint8 v, bytes32 r, bytes32 s) internal view {
        bytes32 messageHash = keccak256(abi.encodePacked(_orderId, _status));
        bytes32 ethSignedMessageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
        require(ecrecover(ethSignedMessageHash, v, r, s) == teeEnclaveKey, "Invalid TEE Signature! Tampering detected.");
    }

    // Happy Path: TEE 验证通过，自动抽水并打款
    function settle(bytes32 _orderId, uint8 v, bytes32 r, bytes32 s) external {
        _verifyTEESignature(_orderId, "SUCCESS_COMPLIANT", v, r, s);
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Invalid");
        
        order.state = EscrowState.Settled;
        
        // Tokenomics: 计算 2% 协议抽水
        uint256 fee = (order.budget * PROTOCOL_FEE_BPS) / 10000;
        uint256 sellerPayout = order.budget - fee;

        IERC20(order.token).transfer(treasuryDAO, fee); // 利润归入国库
        IERC20(order.token).transfer(order.sellerAgent, sellerPayout + order.stakeAmount); // 剩余钱+保证金给卖家
    }

    // Fail Path: 退款
    function refund(bytes32 _orderId, uint8 v, bytes32 r, bytes32 s) external {
        _verifyTEESignature(_orderId, "FAILED_VERIFICATION_REFUNDED", v, r, s);
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Invalid");
        
        order.state = EscrowState.Refunded;
        IERC20(order.token).transfer(order.buyerAgent, order.budget);
        IERC20(order.token).transfer(order.sellerAgent, order.stakeAmount);
    }

    // Penalty Path: 作恶罚没
    function slash(bytes32 _orderId, uint8 v, bytes32 r, bytes32 s) external {
        _verifyTEESignature(_orderId, "MALICIOUS_DELIVERY_PENALTY", v, r, s);
        Order storage order = escrows[_orderId];
        require(order.state == EscrowState.Accepted, "Invalid");
        
        order.state = EscrowState.Slashed;
        // 质押金全扣，全额补偿给买家
        IERC20(order.token).transfer(order.buyerAgent, order.budget + order.stakeAmount);
    }
}
