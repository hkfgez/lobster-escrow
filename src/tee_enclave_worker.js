/**
 * src/tee_enclave_worker.js
 * * 模拟在 Trusted Execution Environment (TEE) 中运行的独立验证预言机。
 * 所有大模型的 JSON 输出必须经过此隔离环境校验，并使用 Enclave 内部私钥签名，
 * 智能合约只认此签名，杜绝任何外部 API 篡改可能。
 */
const { ethers } = require("ethers");
require("dotenv").config();

// TEE Enclave 内部绝对隔离的私钥 (仅用于演示，实际生产中此密钥对外部不可见)
const ENCLAVE_PRIVATE_KEY = process.env.TEE_PRIVATE_KEY || "0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef";

async function executeTEEVerification(orderId, llmOutputJson) {
    console.log(`[TEE Enclave] Secure runtime initiated for Order: ${orderId}`);
    
    // 1. 在隔离环境中解析大模型的结果
    let finalStatus = "";
    if (llmOutputJson.sources_approved && llmOutputJson.fields_complete) {
        finalStatus = "SUCCESS_COMPLIANT";
    } else if (llmOutputJson.malicious_intent_detected) {
        finalStatus = "MALICIOUS_DELIVERY_PENALTY";
    } else {
        finalStatus = "FAILED_VERIFICATION_REFUNDED";
    }

    // 2. 使用 TEE 私钥对结果进行 ECDSA 签名
    const wallet = new ethers.Wallet(ENCLAVE_PRIVATE_KEY);
    const messageHash = ethers.utils.solidityKeccak256(["bytes32", "string"], [orderId, finalStatus]);
    const messageHashBytes = ethers.utils.arrayify(messageHash);
    const signature = await wallet.signMessage(messageHashBytes);

    const sig = ethers.utils.splitSignature(signature);

    console.log(`[TEE Enclave] Verdict: ${finalStatus}`);
    console.log(`[TEE Enclave] Signature generated. Outputting to Onchain OS...`);

    // 3. 输出给智能合约 (合约中 ecrecover 会验证此签名)
    return {
        orderId: orderId,
        status: finalStatus,
        v: sig.v,
        r: sig.r,
        s: sig.s
    };
}

module.exports = { executeTEEVerification };
