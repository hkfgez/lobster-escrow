import { EscrowStatus } from "../types";

const transitions: Record<EscrowStatus, EscrowStatus[]> = {
  Draft: ["Funded"],
  Funded: ["Accepted", "Refunded"],
  Accepted: ["Delivered", "Refunded"],
  Delivered: ["Verified", "Refunded"],
  Verified: ["Settled"],
  Settled: [],
  Refunded: []
};

export class EscrowStateMachine {
  private status: EscrowStatus = "Draft";

  getStatus(): EscrowStatus {
    return this.status;
  }

  transition(next: EscrowStatus): EscrowStatus {
    if (!transitions[this.status].includes(next)) {
      throw new Error(`Invalid transition: ${this.status} -> ${next}`);
    }
    this.status = next;
    return this.status;
  }
}
