import { DeliveryReport, EscrowOrder, VerificationResult } from "../types";

export function verifyDelivery(
  order: EscrowOrder,
  report: DeliveryReport,
  deliveredInMinutes: number
): VerificationResult {
  const deadline_valid = deliveredInMinutes <= order.delivery_deadline_minutes;

  const fields_complete =
    !!report.summary &&
    Array.isArray(report.signals) &&
    report.signals.length >= 3 &&
    Array.isArray(report.sources) &&
    !!report.generated_at;

  const schema_valid = fields_complete;

  const sources_approved = report.sources.every((s) =>
    order.accepted_sources.includes(s)
  );

  const passed =
    deadline_valid && fields_complete && schema_valid && sources_approved;

  return {
    status: passed ? "verified" : "rejected",
    checks: {
      deadline_valid,
      fields_complete,
      schema_valid,
      sources_approved
    },
    reason: passed
      ? "All verification checks passed."
      : "Delivery failed verification."
  };
}
