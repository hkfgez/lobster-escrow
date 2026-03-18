# Architecture

## Core modules

### 1. Claw Intent Parser
Transforms natural-language service requests into structured Escrow Orders.

### 2. Buyer Agent
Requests quotes, selects a Seller Agent, and initiates escrow funding.

### 3. Seller Agent
Accepts the order and submits a structured delivery report.

### 4. Verification Engine
Evaluates delivery against explicit escrow rules:
- deadline_valid
- fields_complete
- schema_valid
- sources_approved

### 5. Escrow State Machine
Controls workflow transitions.

### 6. Settlement Engine
Releases funds or triggers refund based on verification result.

### 7. Audit Logger
Produces a final transaction summary for traceability.

## State machine

Happy Path:
Draft → Funded → Accepted → Delivered → Verified → Settled

Fail Path:
Draft → Funded → Accepted → Delivered → Refunded

## Execution layer
OKX Onchain OS

## Intent compiler
Claw
