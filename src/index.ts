/**
 * @notice Lobster Escrow 5.0 - Omnichain State Machine Entry
 * @dev This orchestrator triggers the deterministic Escrow flow. 
 * Note: Happy/Fail path deliveries are mocked here for reproducibility, 
 * but the underlying state transitions strictly map to LobsterEscrow.sol.
 */
import { EscrowStateMachine } from "./engine/escrowStateMachine";
import { verifyDelivery } from "./agents/verifierAgent";
import { resolveEscrow } from "./engine/settlementEngine";
import { EscrowOrder } from "./types";
import happyDelivery from "../mock-data/happy_delivery.json";
import failDelivery from "../mock-data/fail_delivery.json";

const order: EscrowOrder = {
  task_type: "btc_whale_report",
  budget_limit: 30,
  delivery_deadline_minutes: 10,
  required_fields: ["summary", "signals", "sources", "generated_at"],
  accepted_sources: ["Glassnode", "Arkham", "Whale Alert"],
  settlement_rule: "Release funds only if verification passes.",
  refund_rule: "Refund Buyer Agent if verification fails."
};

function runScenario(label: string, delivery: any) {
  const machine = new EscrowStateMachine();
  machine.transition("Funded");
  machine.transition("Accepted");
  machine.transition("Delivered");

  const verification = verifyDelivery(order, delivery, 8);
  const resolution = resolveEscrow(machine, verification);

  console.log(`\n=== ${label} ===`);
  console.log("Verification:", verification);
  console.log("Resolution:", resolution);
  console.log("Final Status:", machine.getStatus());
}

runScenario("Happy Path", happyDelivery);
runScenario("Fail Path", failDelivery);
