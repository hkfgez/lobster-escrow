export type EscrowStatus =
  | "Draft"
  | "Funded"
  | "Accepted"
  | "Delivered"
  | "Verified"
  | "Settled"
  | "Refunded";

export interface EscrowOrder {
  task_type: string;
  budget_limit: number;
  delivery_deadline_minutes: number;
  required_fields: string[];
  accepted_sources: string[];
  settlement_rule: string;
  refund_rule: string;
  assumptions?: string[];
}

export interface DeliveryReport {
  summary: string;
  signals: string[];
  sources: string[];
  generated_at: string;
}

export interface VerificationResult {
  status: "verified" | "rejected";
  checks: {
    deadline_valid: boolean;
    fields_complete: boolean;
    schema_valid: boolean;
    sources_approved: boolean;
  };
  reason: string;
}
