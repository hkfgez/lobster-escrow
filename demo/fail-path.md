# Fail Path Demo

## Scenario
Buyer Agent purchases a BTC whale-movement research report from Seller Agent.

## Failure condition
Seller Agent uses an unapproved data source.

## Steps
1. User request is submitted
2. Claw compiles Escrow Order
3. Seller Agent accepts task
4. Escrow is funded
5. Seller Agent submits delivery
6. Verification fails because `sources_approved = false`
7. Refund is triggered
8. Audit Log is generated

## Final state
Refunded
