# Lobster Escrow

**Verifiable Agent-to-Agent Escrow Executor on OKX Onchain OS**

Lobster Escrow is an agent-native escrow executor that enables buyer and seller agents to complete service trading through structured intent parsing, escrow-protected funding, rule-based delivery verification, automatic settlement or refund, and audit-ready transaction logging.

## Why this project exists

Today, most agents can already execute tasks, call tools, and generate outputs.  
However, they still cannot safely transact with each other.

A buyer agent may want to purchase a report, a data service, or a research task from a seller agent.  
But four critical layers are still missing in most agent systems:

- escrow-protected payment
- rule-based delivery verification
- automatic settlement or refund
- audit-ready transaction logs

Lobster Escrow fills that gap.

## Core idea

Lobster Escrow does not aim to make agents better at conversation.  
It enables agents to transact under **programmable trust**.

It upgrades agents from task executors into **transacting economic entities**.

## Demo scenario

This repository focuses on one minimal and realistic Web3 scenario:

**A Buyer Agent purchases a BTC whale-movement research report from a Seller Agent.**

The request includes explicit conditions:

- budget limit
- delivery deadline
- required output fields
- approved data sources
- settlement rule
- refund rule

This makes the workflow clear, evaluable, and reproducible.

## Workflow

1. User submits a natural-language service request  
2. Claw compiles it into a structured Escrow Order  
3. Buyer Agent selects a Seller Agent and funds escrow  
4. Seller Agent delivers a structured report  
5. Verification Engine checks deadline, fields, schema, and sources  
6. Settlement Engine releases funds or refunds automatically  
7. Audit Log is generated

## State machine

**Happy Path**  
Draft → Funded → Accepted → Delivered → Verified → Settled

**Fail Path**  
Draft → Funded → Accepted → Delivered → Refunded

## Why OKX Onchain OS

Lobster Escrow does not use OKX Onchain OS as a wrapper.  
It uses Onchain OS as the execution operating layer for agent-native service settlement.

**Claw** acts as the intent compiler that transforms natural-language service requests into executable escrow orders.

## Repository contents

- `prompts/` — system prompts and role prompts
- `schemas/` — escrow, delivery, verification, and audit schemas
- `mock-data/` — happy path and fail path demo data
- `demo/` — walkthroughs and sample flows
- `docs/` — architecture, scoring alignment, reproducibility
- `src/` — minimal TypeScript workflow implementation
- `videos/` — demo video references
- `screenshots/` — visual assets for submission and repo reading

## Reproducibility

This repository is reproducible at the workflow level, not only at the concept level.

It includes:

- prompt design
- escrow order schema
- delivery schema
- verification logic
- state machine logic
- mock workflow data
- happy path demo
- fail path demo
- audit log outputs

## Happy Path

The main demo shows how funds are released when delivery satisfies all escrow release rules.

## Fail Path

The supplementary demo shows how funds are automatically refunded when delivery fails verification.

This proves that Lobster Escrow supports both **settlement** and **refund** paths under explicit rules.

## Key innovation

Most agent systems today focus on task execution.  
Lobster Escrow focuses on **service settlement between agents**.

That is the missing layer this project is designed to provide.

## One-line summary

**Agents can now transact under programmable trust.**
