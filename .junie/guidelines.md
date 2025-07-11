# Repository Guidelines

Super project guidelines and instructions

## Prime directive:

Always comply with guidelines and instructions.

## Repository Organization

- `.junie/` contain AI agent related files.
- `src/` contain repository source code.
- `tests/` contain tests files.
- `artifact/` contain project artifact such as experimental log, plot and rosbag.
- `tests/tests_bats/` contain N2ST bats framework files that are mainly used for unit-testing
- `tests/tests_dryrun_and_tests_scripts/` contain integration tests
- `utilities/` contain external libraries such as N2ST, NBS and mock repository
- `utilities/tmp/dockerized-norlab-project-mock-EMPTY` is use for cloning a fresh copy of a mock "super project" from https://github.com/norlab-ulaval/dockerized-norlab-project-mock-EMPTY.git on test execution.
  `dockerized-norlab-project-mock-EMPTY` is a mock of how a user would install and uses TNP. We refer to this as a "super project."


## General Instructions

None

## Coding instructions

- Path management: each script can optionally use the env var `PLACEHOLDER_PATH`, `*_PATH` (assuming `PLACEHOLDER_PATH` was renamed), `PROJECT_PATH`, `NBS_PATH` (if available), `N2ST_PATH` (if available) and others define in `.env.*` (assuming `.env.template-norlab-project.template` was renamed).


## Testing Instructions

None

## Final Instructions

- In addition to repository guidelines, also review _A2G super project guidelines configuration_
  specified in `.junie/guidelines.a2g.md`.
- If any guideline instructions are ambiguous or contradict each others, ask for clarification or
  additional instructions instead of guessing.
