#!/bin/bash
# ===============================================================================================
# Teardown integration test
#
# Usage:
#   $ bash teardown_integration_test.bash
#
# Requirement: Must be executed before 'tnp::teardown_mock' function
#
# Notes:
#   See utilities/tmp/README.md for details on role of `dockerized-norlab-project-mock-EMPTY`
#
# Global:
#   read TNP_PATH
#   read N2ST_PATH
#
# =================================================================================================
pushd "$(pwd)" >/dev/null || exit 1

function tnp::teardown_mock_semantic_release_files() {
  n2st::print_formated_script_header "teardown_integration_test.bash" "${MSG_LINE_CHAR_UTIL}"

  local tnp_mock_repo_path="${TNP_PATH:?err}/utilities/tmp/dockerized-norlab-project-mock-EMPTY"
  {
    rm -R "${tnp_mock_repo_path}/.github/workflows" && \
    rm -R "${tnp_mock_repo_path}/.releaserc.json" ;
  } || tree -L 2 -a "${tnp_mock_repo_path}"

  n2st::print_formated_script_footer "teardown_integration_test.bash" "${MSG_LINE_CHAR_UTIL}"
  return 0
}


# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # This script is being run, ie: __name__="__main__"

  cd "${N2ST_PATH:?'Variable not set'}" || exit 1
  source "import_norlab_shell_script_tools_lib.bash" || exit 1
  tnp::teardown_mock_semantic_release_files

else
  # This script is being sourced, ie: __name__="__source__"
  tnp_error_prefix="\033[1;31m[TNP error]\033[0m"
  echo -e "${tnp_error_prefix} This script must executed with bash! i.e.: $ bash $( basename "$0" )" 1>&2
  exit 1
fi

# ====Teardown=====================================================================================
popd >/dev/null || exit 1


