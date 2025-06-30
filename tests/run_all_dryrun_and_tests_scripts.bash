#!/bin/bash
# =================================================================================================
# Run all tests script in tests_dryrun_and_tests_scripts
#
# Usage:
#   $ bash run_all_dryrun_and_tests_scripts.bash
#
# =================================================================================================

tnp_root=$(git rev-parse --show-toplevel)

bash "${tnp_root}/tests/tests_dryrun_and_tests_scripts/dryrun_configure_github_branch_protection.bash"
EXIT_CODE=$?


exit $EXIT_CODE
