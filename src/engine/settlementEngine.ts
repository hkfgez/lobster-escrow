import { EscrowStateMachine } from "./escrowStateMachine";
import { VerificationResult } from "../types";

export function resolveEscrow(
  machine: EscrowStateMachine,
  verification: VerificationResult
): string {
  if (machine.getStatus() !== "Delivered") {
    throw new Error("Escrow must be Delivered before resolution.");
  }

  if (verification.status === "verified") {
    machine.transition("Verified");
    machine.transition("Settled");
    return "Funds released to Seller Agent.";
  }

  machine.transition("Refunded");
  return "Funds refunded to Buyer Agent.";
}
