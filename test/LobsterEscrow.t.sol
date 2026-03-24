// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/LobsterEscrow.sol";

// --- 模拟硬件预言机 (Mock Oracles) ---
contract MockReclaimZkTLS {
    function verifyProof(IReclaimZkTLSVerifier.Proof memory) external pure returns (bool) {
        return true; // 模拟本地 zkTLS 验证永远通过
    }
}

contract MockAutomataTEE {
    function verifyAttestation(bytes memory) external pure returns (bool) {
        return true; // 模拟本地 SGX 硬件验证永远通过
    }
}

// --- 核心测试用例 ---
contract LobsterEscrowTest is Test {
    LobsterEscrow public escrow;
    MockReclaimZkTLS public mockZkTLS;
    MockAutomataTEE public mockTEE;

    address public buyer = address(0x1);
    address public seller = address(0x2);
    address public treasury = address(0x3);

    function setUp() public {
        mockZkTLS = new MockReclaimZkTLS();
        mockTEE = new MockAutomataTEE();
        
        escrow = new LobsterEscrow(treasury);
        escrow.setOracleEndpoints(address(mockZkTLS), address(mockTEE));
        
        vm.deal(buyer, 100 ether);
        vm.deal(seller, 100 ether);
    }

    // 🧪 测试用例 1: 成功的 A2A 交易流转 (Happy Path)
    function test_HappyPath_Settlement() public {
        // 1. 买方锁资创建订单
        vm.prank(buyer);
        uint256 escrowId = escrow.createEscrow{value: 10 ether}(seller);

        // 2. 卖方 1:1 质押接单
        vm.prank(seller);
        escrow.acceptAndStake{value: 10 ether}(escrowId);

        // 3. 卖方提交带有 zkTLS 和 TEE 证明的交付物
        vm.prank(seller);
        IReclaimZkTLSVerifier.Proof memory dummyProof;
        escrow.submitZkTLSDelivery(escrowId, "{}", dummyProof, "0xSGX");

        // 4. 模拟度过挑战期
        vm.warp(block.timestamp + 25 hours);

        // 5. 结算抽水
        escrow.executeSettlement(escrowId);

        // 验证国库是否收到了 2% 的钱
        assertEq(treasury.balance, 0.2 ether);
    }

    // 🧪 测试用例 2: 卖方作恶被罚没 (Slashing Path)
    function test_SlashingPath() public {
        vm.prank(buyer);
        uint256 escrowId = escrow.createEscrow{value: 10 ether}(seller);

        vm.prank(seller);
        escrow.acceptAndStake{value: 10 ether}(escrowId);

        vm.prank(seller);
        IReclaimZkTLSVerifier.Proof memory dummyProof;
        escrow.submitZkTLSDelivery(escrowId, "{}", dummyProof, "0xSGX");

        // 买方发起挑战 (Challenge)
        vm.prank(buyer);
        escrow.challengeDelivery(escrowId, "0xFraudProof");

        // 协议执行极其冷酷的罚没 (Slash)
        escrow.executeSlash(escrowId, buyer);

        // 验证买方是否拿回了原款 + 卖方 50% 的保证金罚金 (10 + 5)
        assertEq(buyer.balance, 105 ether); 
    }
}
