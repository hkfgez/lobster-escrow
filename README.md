# Lobster Escrow｜龙虾托管官
## Verifiable Agent-to-Agent Escrow, Verification, and Settlement Layer on OKX Onchain OS

Lobster Escrow is a **Verifiable Agent-to-Agent Escrow, Verification, and Settlement Layer** built on **OKX Onchain OS + Claw**.

It allows a Buyer Agent and a Seller Agent to complete a full service-trading loop under explicit rules:

**task request → escrow funding → structured delivery → rule-based verification → automatic settlement / automatic refund → audit logging**

This project is not a generic chatbot workflow and not a one-off payment script.

It is a minimal trust infrastructure for **Agent-to-Agent commerce**.

---

## Why this project exists

Most AI Agents today can already search, reason, call tools, and generate results.

But when one Agent wants to **buy a service** from another Agent, a critical layer is still missing:

Agents still cannot reliably **transact under rules**.

In practice, a Buyer Agent and a Seller Agent need more than task completion.  
They need a machine-enforced transaction framework with five core components:

- **Escrow** — funds are locked before delivery, not paid upfront
- **Verification** — output is accepted by explicit rules, not subjective judgment
- **Settlement** — valid delivery triggers payment release
- **Refund** — invalid delivery triggers automatic refund
- **Audit Log** — every step is recorded for traceability and review

Lobster Escrow is designed to fill exactly this missing layer.

It turns Agent-to-Agent collaboration from “can work together” into **can transact under programmable trust**.

---

## Claw model & LLM version

- **Claw**: OpenClaw2026.3
- **LLM**: GPT5.4 / Gemini3.1 Pro
- **Runtime**: Windows 11 + Telegram integration

---

## One-line definition

**Lobster Escrow is a minimal programmable trust primitive for Agent-to-Agent service exchange.**

It enables Buyer Agents and Seller Agents to complete service transactions under explicit release and refund rules on **OKX Onchain OS**, with **Claw** compiling natural-language intent into machine-readable escrow contracts.

---

## Why OKX Onchain OS + Claw is essential

Lobster Escrow does not merely “use” OKX Onchain OS and Claw.  
Its core workflow depends on them.

### Claw as contract compiler

Claw is not used here as a generic chat interface.  
It acts as an **intent compiler** that transforms natural-language service requests into a machine-readable **Escrow Order**.

For example, a user request such as:

> Find an Agent that can deliver a BTC whale activity report within 10 minutes, budget 30 USDT, include 3 on-chain signals, and only use approved data sources.

is compiled into a structured order containing:

- `task_type`
- `budget_limit`
- `delivery_deadline`
- `required_fields`
- `accepted_sources`
- `settlement_rule`
- `refund_rule`

Without Claw, the system only has vague human intent.  
With Claw, it obtains a machine-executable transaction contract.

### OKX Onchain OS as native workflow execution layer

OKX Onchain OS is not an outer shell here.  
It is the execution substrate that carries the escrow workflow as a **stateful transaction pipeline**, rather than as a loose chain of scripts.

The full state transition is:

**Draft → Funded → Accepted → Delivered → Verified → Settled / Refunded**

Without OKX Onchain OS, this project would degrade into isolated scripts and manual orchestration.  
With OKX Onchain OS, it becomes a native workflow for escrow, verification, settlement, refund, and audit.

**In short:**

- Without **Claw**, there is no executable escrow contract
- Without **OKX Onchain OS**, there is no native settlement state machine

That is why their integration is not optional.  
It is foundational.

---

## Real problem, clear users, immediate utility

Lobster Escrow is built for a real and recurring problem:

> How can one Agent safely purchase a result from another Agent without relying on subjective trust?

### Target users

This project is designed for:

- **Buyer Agents** that need to purchase structured results
- **Seller Agents** that provide reports, signals, or data services
- **Builders** who want a reusable escrow / verification / settlement layer for Agent marketplaces or service workflows

### Immediately usable scenarios

Although the demo focuses on one BTC report scenario, the workflow is reusable across multiple service types:

- **Research delivery**  
  Example: BTC whale activity report, protocol analysis, address intelligence

- **Signal delivery**  
  Example: structured trading signals that must satisfy field, timing, and source constraints

- **Data retrieval delivery**  
  Example: on-chain summaries for a wallet, token, or protocol using approved sources only

So this project is not only about “buying one report”.  
It addresses a broad class of **A2A service acceptance and settlement disputes**.

---

## Minimal demo scenario

To keep the system clear, reproducible, and easy to evaluate, the current implementation focuses on one minimal closed-loop use case:

**A Buyer Agent purchases a BTC on-chain whale activity report from a Seller Agent.**

The Buyer specifies:

- delivery deadline
- budget limit
- required output fields
- accepted data sources
- release rule
- refund rule

Claw compiles this request into a structured Escrow Order.  
The Seller Agent submits a delivery payload in the required format.  
The Verification Engine checks whether the result satisfies the rules.  
The system then moves to either **Settled** or **Refunded**.

This scenario is intentionally narrow, not because the system is narrow, but because a minimal closed loop is easier to audit and reproduce.

---

## What exactly is being verified?

The core of Lobster Escrow is not just “holding funds”, but **verifying delivery under explicit rules**.

The Verification Engine checks items such as:

- **deadline_valid** — was the delivery submitted on time?
- **fields_complete** — are all required fields present?
- **schema_valid** — does the output match the delivery schema?
- **sources_approved** — were only approved data sources used?
- **settlement_rule_matched** — are payment release conditions satisfied?
- **refund_rule_triggered** — should refund conditions be activated?

This is the key design shift:

**Lobster Escrow does not rely on human interpretation after delivery.**  
**It turns service requirements into machine-verifiable settlement conditions.**

---

## Workflow

The current workflow is:

1. User submits a natural-language service request
2. Claw compiles it into a structured **Escrow Order**
3. Buyer Agent selects Seller Agent and locks funds into escrow
4. Seller Agent submits a structured **Delivery Payload**
5. Verification Engine checks rules for format, fields, timing, and sources
6. If all release rules pass, funds are settled to the Seller Agent
7. If any required rule fails, funds are refunded to the Buyer Agent
8. Audit Log is generated for the full execution path

This is not a chat-style collaboration demo.  
It is a **verifiable, traceable, adjudicable service transaction workflow**.

---

## State machine

Lobster Escrow is built around an explicit escrow state machine:

**Draft → Funded → Accepted → Delivered → Verified → Settled / Refunded**

This matters for two reasons:

1. It makes the project **engineering-friendly and explainable**
2. It ensures the transaction is not a one-shot script, but a rule-governed process with explicit terminal states

---

## Happy Path and Fail Path

Most demos only prove that a workflow can succeed.

Lobster Escrow proves both that it can **succeed correctly** and **fail correctly**.

### Happy Path

When the Seller Agent submits a valid delivery that satisfies all release rules:

**Draft → Funded → Accepted → Delivered → Verified → Settled**

Funds are automatically released to the Seller Agent.

### Fail Path

When the Seller Agent submits a delivery that violates rules — for example, by using a source outside the approved whitelist:

**Draft → Funded → Accepted → Delivered → Refunded**

Payment is rejected, funds are automatically refunded to the Buyer Agent, and an Audit Log is recorded.

This is one of the most important aspects of the project:

**`Refunded` is not an exception path.**  
**It is a first-class terminal state of programmable trust.**

That means Lobster Escrow is not designed merely to “complete a transaction”.  
It is designed to **judge whether a transaction deserves completion**.

---

## Key innovation

The innovation of Lobster Escrow is not simply “adding escrow to agents”.

It has three distinct layers of novelty:

### 1. Agents become economic entities, not only task executors

Most current agent systems stop at “doing work”.  
Lobster Escrow moves one step further: enabling Agents to **exchange value under rules**.

### 2. Natural-language service intent becomes a machine-verifiable contract

Instead of leaving service acceptance to human interpretation, Lobster Escrow compiles human requests into explicit, machine-checkable escrow conditions.

### 3. Refund is institutionalized as a valid terminal state

Most systems only demonstrate successful completion.  
Lobster Escrow also demonstrates correct refusal, correct refund, and correct audit.

This makes the project less like a feature demo and more like a minimal **Agent commerce infrastructure primitive**.

---

## Repository structure

```text
.
├── demo/
│   ├── happy-path.md
│   └── fail-path.md
├── docs/
│   ├── architecture.md
│   ├── overview.md
│   ├── reproducibility.md
│   └── scoring-alignment.md
├── mock-data/
├── prompts/
│   ├── system.md
│   ├── claw_intent_parser.md
│   ├── buyer_agent.md
│   ├── seller_agent.md
│   ├── verifier_agent.md
│   └── audit_logger.md
├── schemas/
│   ├── escrow_order.schema.json
│   ├── delivery_report.schema.json
│   ├── verification_result.schema.json
│   └── audit_log.schema.json
├── src/
│   ├── agents/
│   ├── engine/
│   ├── index.ts
│   └── types.ts
├── README.md
└── package.json
```

Reproducibility

This repository is intended to be reproducible not only at the demo level, but at the decision level.

That means another builder should be able to reproduce:

how natural-language intent is compiled

how escrow constraints are represented

how delivery is structured

how verification determines pass / fail

how settlement or refund is chosen

how the audit trail is produced

Public reproducibility assets

The repository includes:

Prompt templates

Claw compilation logic

Escrow Order schema

Delivery schema

Verification rules

Escrow state machine

Happy Path demo

Fail Path demo

Mock data

README reproduction steps

Open-source implementation

Reproduction steps

Read docs/overview.md and docs/architecture.md

Inspect prompts/ to understand role definitions and intent compilation

Inspect schemas/ to understand order, delivery, verification, and audit structures

Review mock-data/ for sample payloads

Review demo/happy-path.md and demo/fail-path.md

Run the TypeScript workflow in src/

Compare resulting state transitions and audit outputs

The project goal is not only to describe the idea, but to make it:

reproducible at the workflow level and understandable at the decision level

Example escrow order
```json
{
  "task_type": "btc_whale_report",
  "budget_limit": 30,
  "delivery_deadline": "10m",
  "required_fields": ["signal_1", "signal_2", "signal_3"],
  "accepted_sources": ["approved_source_a", "approved_source_b"],
  "settlement_rule": "release_if_all_checks_pass",
  "refund_rule": "refund_if_any_required_check_fails"
}
```
Example failed verification result
```json
{
  "deadline_valid": true,
  "fields_complete": true,
  "schema_valid": true,
  "sources_approved": false,
  "decision": "REFUNDED",
  "reason": "UNAPPROVED_SOURCE"
}
```
Why this matters

If AI Agents are going to enter real economic activity, they will need more than task execution.

They will need a way to:

transact under rules

accept or reject delivery under rules

settle value under rules

keep audit trails under rules

That is the role Lobster Escrow is trying to play.

It is a small starting point, but it points toward a larger direction:

from agents that work, to agents that can trade under programmable trust

Open-source repository

GitHub: https://github.com/hkfgez/lobster-escrow
