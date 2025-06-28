#!/bin/bash
# =================================================================================================
# Execute 'template-norlab-project' repo shell script tests via 'norlab-shell-script-tools' library
#
# Usage:
#   $ bash run_bats_core_test_in_n2st.tnp.bash ['<test-directory>[/<this-bats-test-file.bats>]' ['<image-distro>']]
#
# Arguments:
#   - ['<test-directory>']     The directory from which to start test, default to 'tests'
#   - ['<test-directory>/<this-bats-test-file.bats>']  A specific bats file to run, default will
#                                                      run all bats file in the test directory
#
# Globals: none
#
# =================================================================================================
params=( "$@" )

if [[ -z ${params[0]} ]]; then
  # Set to default bats tests directory if none specified
  params="tests/tests_bats/"
fi

function tnp::run_n2st_testing_tools(){

  # ....Project root logic.........................................................................
  local tnp_root
  tnp_root=$(git rev-parse --show-toplevel)

  # ....Load environment variables from file.......................................................
  cd "${tnp_root}" || exit 1
  set -o allexport
  source .env.template-norlab-project.template
  set +o allexport

  local tnp_path=${PROJECT_PATH}
  TNP_GIT_CURRENT_BRANCH=$(git symbolic-ref -q --short HEAD || git describe --all --exact-match)

  if [[ ${TEAMCITY_VERSION} ]] ; then
    TNP_TEAMCITY_PR_SOURCE=${TNP_TEAMCITY_PR_SOURCE:?'Variable must be set manually by TC run configuration using
TNP_TEAMCITY_PR_SOURCE=%teamcity.pullRequest.source.branch%
export TNP_TEAMCITY_PR_SOURCE
'}
  fi

  ( \
    echo "TNP_GIT_REMOTE_URL=${PROJECT_GIT_REMOTE_URL}"; \
    echo "TNP_GIT_NAME=${PROJECT_GIT_NAME}"; \
    echo "TNP_GIT_CURRENT_BRANCH=${TNP_GIT_CURRENT_BRANCH}"; \
    echo "TNP_TEAMCITY_PR_SOURCE=${TNP_TEAMCITY_PR_SOURCE}"; \
  ) > "${tnp_path}/tests/.env.tnp_test_values"

  # ....Execute N2ST run_bats_tests_in_docker.bash.................................................
  # shellcheck disable=SC2086
  bash "${N2ST_PATH:?err}/tests/bats_testing_tools/run_bats_tests_in_docker.bash" "${params[@]}"

  # ....Teardown...................................................................................
  cd "${tnp_root}" || return 1
  return 0
  }

tnp::run_n2st_testing_tools

