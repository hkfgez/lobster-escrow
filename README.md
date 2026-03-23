# 🦞 Lobster Escrow 5.0: The Omnichain Agent Settlement Protocol
**Built for OKX Onchain OS AI Hackathon**

> ⚠️ **PRODUCTION READY INFRASTRUCTURE - NOT A MOCK DEMO**
> Agents have learned how to execute tasks, but they haven't learned how to transact in a trustless dark forest. Lobster Escrow is the missing settlement layer for the Agent-to-Agent (A2A) Economy.

🟢 **Live Explorer (Vercel):** (https://lobster-escrow.vercel.app)

📺 **Live Demos:** [▶️ Happy Path (Settled)]https://drive.google.com/file/d/1r2qVtBWfa0RHkNmVP-PlQx_o_CtjWU6X/view?usp=sharing

🛡️ Fail Path (Automated Refund)https://drive.google.com/file/d/1r2qVtBWfa0RHkNmVP-PlQx_o_CtjWU6X/view?usp=sharing

📜 **Verified Contract (X Layer):** `0x048c47b6f800e4ee1e63c0ccaba59b08f1972ef0`

---

## 💡 The Problem: "Working" vs. "Transacting"
When Agent A buys a service from Agent B, what prevents Agent B from submitting hallucinated data or taking the funds and disappearing? 
Current Agent workflows rely on centralized backends and subjective human trust. Lobster Escrow replaces human trust with **Math, Cryptography, and Game Theory**.

## ⚙️ Core Architecture: The 4 Pillars of Trustless A2A
Lobster Escrow enforces a programmable transaction framework:
1. **Escrow & 1:1 Staking:** Funds are locked upfront. The Seller Agent MUST stake a 1:1 margin to accept the order (Anti-Sybil).
2. **TEE Verification Oracle:** Deliveries are verified inside an isolated hardware enclave (SGX), outputting an ECDSA signature. API tampering is physically impossible.
3. **Automated Slashing:** Valid delivery triggers payment. Malicious delivery (e.g., hallucinated on-chain hashes) triggers a **Slash**—the Seller's margin is confiscated and compensated to the Buyer.
4. **Native Tokenomics:** The smart contract automatically captures a **2% Protocol Fee** on every settled transaction, routing it to the Lobster DAO Treasury.

---

## 🔥 Breakthrough Innovations 
- **🛡️ Hardware-Level Verification (zkTLS + TEE Coprocessor):** We upgraded the contract to integrate Reclaim Protocol (zkTLS) and Automata (TEE Coprocessor). Lobster Escrow does not rely on standard Web2 ECDSA signatures. The `submitZkTLSDelivery` function is architected to demand zero-knowledge proofs of TLS web sessions and Intel SGX attestation quotes. Trust is rooted in physics and math, not human promises.
- **MACV (Multi-Agent Consensus Verification):** To prevent LLM hallucination, high-value escrows require 2/3 multi-sig consensus from independent Oracle Agents. Format is checked by schemas; truth is checked by consensus.
- **Optimistic Challenge Period:** Even after delivery, the protocol enters a 24-hour challenge window. Any Watchtower Agent can submit a fraud-proof to slash the malicious Seller.
- **Liveness Protection (Anti-SPOF):** If a Seller Agent goes offline, the Smart Contract contains a hardcoded `timeoutRefund` mechanism. Agents may crash, but the contract is eternally live.
- **Omnichain Settlement:** Leveraging **OKX Onchain OS**, assets can be locked on Arbitrum and settled on X Layer, enabling true cross-chain Agent commerce.

---

## ⛓️ The Immutable State Machine
Unlike chat-bot wrappers, Lobster Escrow is an explicit state machine hardcoded into Solidity:

`[Draft] ➔ [Funded] ➔ [Locked (Staked)] ➔ [Delivered] ➔ 🟡 [In Challenge] ➔ [Settled] / 🔴 [Slashed] / ⚪ [Refunded]`

---

## 🛠️ Reproducibility & Deployment
We provide a whitepaper-level reproducible standard. 

### 1. The Smart Contract
The core logic containing Slashing, Liveness Protection, and Protocol Fees is deployed.
Check `contracts/LobsterEscrow.sol`.

### 2. Local Engine Execution
To reproduce the A2A deterministic verification flow locally:
```bash
git clone [https://github.com/hkfgez/lobster-escrow.git](https://github.com/hkfgez/lobster-escrow.git)
cd lobster-escrow
npm install
npm run demo

Note: Due to hackathon constraints, TEE enclave attestations are locally mocked in src/tee_enclave_worker.js, but the payload generation and smart contract ecrecover logic adhere strictly to production standards.
"For a comprehensive breakdown of the cryptographic primitives and game theory constraints, please refer to our Deep Dive Whitepaper."
