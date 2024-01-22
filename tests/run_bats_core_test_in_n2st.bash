#!/bin/bash
# =================================================================================================
# Execute 'template-norlab-project' repo shell script tests via 'norlab-shell-script-tools' library
#
# Usage:
#   $ bash run_bats_core_test_in_n2st.bash ['<test-directory>[/<this-bats-test-file.bats>]' ['<image-distro>']]
#
# Arguments:
#   - ['<test-directory>']     The directory from which to start test, default to 'tests'
#   - ['<test-directory>/<this-bats-test-file.bats>']  A specific bats file to run, default will
#                                                      run all bats file in the test directory
#
# Globals: none
#
# =================================================================================================
PARAMS="$@"

if [[ -z $PARAMS ]]; then
  # Set to default bats tests directory if none specified
  PARAMS="tests/tests_bats/"
fi

function n2st::run_n2st_testsing_tools(){
  local TMP_CWD
  TMP_CWD=$(pwd)

  # ....Project root logic.........................................................................
  TNP_ROOT=$(git rev-parse --show-toplevel)
#  N2ST_PATH=${N2ST_PATH:-"./utilities/norlab-shell-script-tools"}

  # ....Load environment variables from file.......................................................
  cd "${TNP_ROOT}" || exit 1
  set -o allexport
  source .env.template-norlab-project.template
  set +o allexport

  TNP_PATH=${PROJECT_PATH}
  TNP_GIT_CURRENT_BRANCH=$(git symbolic-ref -q --short HEAD || git describe --all --exact-match)

  ( \
    echo "TNP_GIT_REMOTE_URL=${PROJECT_GIT_REMOTE_URL}"; \
    echo "TNP_GIT_NAME=${PROJECT_GIT_NAME}"; \
    echo "TNP_GIT_CURRENT_BRANCH=${TNP_GIT_CURRENT_BRANCH}"; \
  ) > "${TNP_PATH}/tests/.env.tnp_test_values"

  # ....Execute N2ST run_bats_tests_in_docker.bash.................................................
  # shellcheck disable=SC2086
  bash "${N2ST_PATH:?err}/tests/bats_testing_tools/run_bats_tests_in_docker.bash" $PARAMS

  # ....Teardown...................................................................................
  cd "$TMP_CWD"
  }

n2st::run_n2st_testsing_tools

