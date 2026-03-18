# Reproducibility

## What is reproducible in this repository?
This repository is designed to be reproducible at the workflow level.

A reader can understand and replay:
- how a natural-language request is compiled
- how escrow funding is represented
- how delivery is structured
- how verification is evaluated
- how settlement or refund is triggered
- how audit logs are recorded

## Reproduction path

1. Read `README.md`
2. Read `docs/architecture.md`
3. Review `prompts/`
4. Review `schemas/`
5. Review `mock-data/`
6. Run the minimal TypeScript demo in `src/`
7. Compare with the videos in `videos/`

## Notes
This repository uses a minimal implementation and mock workflow data for demonstration clarity.
The goal is to show a reproducible protocol workflow, not a production marketplace.
