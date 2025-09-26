# Repository Guidelines

_template-norlab-project (TNP)_ guidelines and instructions


## Repository Description

TNP is a template repository for code-related research projects. It’s meant to help kick-start repository creation by
enabling software engineering research-oriented best practice.


## Repository Guidelines Instructions

1. First, review and learn _A2G Framework Guidelines_ specified in
   `.junie/ai_agent_guidelines/guidelines.a2g_framework.md`.
2. Then review the remaining repository guidelines below.
3. **AI agents must follow the mandatory compliance requirements specified below.**


## Prime directive

Always comply with _A2G Framework Guidelines_, _Repository Guidelines_ and _AI operator_ instructions.


## AI Agent Compliance Requirements

All AI agents must:

1. **Always** review A2G guidelines before starting any task
2. **Always** follow A2G file placement decision tree
3. **Always** check workflow mode in `.junie/a2g_config.yml`
4. **Always** apply A2G task verb interpretation protocols

See A2G general guidelines for complete procedures and requirements.


## Repository Organization

- `.junie/` contains AI agent related files.
- `.junie/ai_agent_guidelines` contains _AI Agent Guidelines (A2G)_ with entrypoint at
  `.junie/ai_agent_guidelines/README.md`.
- `src/` contains repository source code.
- `tests/` contains tests files.
- `artifact/` contains project artifact such as experimental log, plot and rosbag.
- `tests/tests_bats/` contains N2ST bats framework files that are mainly used for unit-testing
- `tests/tests_dryrun_and_tests_scripts/` contains integration tests
- `utilities/` contains external libraries such as N2ST, NBS and a mock repository
- `utilities/tmp/dockerized-norlab-project-mock-EMPTY` is used for cloning a fresh copy of a mock
  super project from https://github.com/norlab-ulaval/dockerized-norlab-project-mock-EMPTY.git
  on test execution.


## Repository Terminology

- `N2ST` is the acronym for `norlab-shell-script-tools` library
- `NBS` is the acronym for `norlab-build-system` library
- `dockerized-norlab-project-mock-EMPTY` is a mock repository of how a user would install and uses
  TNP. We refer to this as a "_super project_."


## Repository Specific Additional Guidelines

Proceed with _AI operator_ instructions
