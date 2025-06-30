#!/bin/bash
# ===============================================================================================
# Teardown dockerized-norlab-project-mock-EMPTY for testing
#
# Usage:
#   $ bash teardown_mock.bash
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

function tnp::teardown_mock() {
  n2st::print_formated_script_header "teardown_mock.bash" "${MSG_LINE_CHAR_UTIL}"

  test -n "${TNP_PATH:?err}" || n2st::print_msg_error_and_exit "Env variable TNP_PATH need to be set and non-empty."
  test -d "${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY" \
    || n2st::print_msg_error_and_exit "The directory ${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY is unreachable"

  # Delete git cloned repo
  rm -rf "${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY"

  # Setup placeholder
  mkdir "${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY"

  # ....Sanity check...............................................................................
  test -d "${TNP_PATH}/utilities" || n2st::print_msg_error_and_exit "The directory ${TNP_PATH}/utilities is unreachable"
  test ! -d "${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY/.git" \
  || { \
    tree -a -L 2 "${TNP_PATH}/utilities/tmp" &&
    n2st::print_msg_error_and_exit "Something went wrong with the deletion of the cloned repository ${TNP_PATH}/utilities/tmp/dockerized-norlab-project-mock-EMPTY/" ;
    }

  n2st::print_formated_script_footer "teardown_mock.bash" "${MSG_LINE_CHAR_UTIL}"
}

# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # This script is being run, ie: __name__="__main__"

  cd "${N2ST_PATH:?'Variable not set'}" || exit 1
  source "import_norlab_shell_script_tools_lib.bash" || exit 1

  tnp::teardown_mock

else
  # This script is being sourced, ie: __name__="__source__"
  tnp_error_prefix="\033[1;31m[TNP error]\033[0m"
  echo -e "${tnp_error_prefix} This script must executed with bash! i.e.: $ bash $( basename "$0" )" 1>&2
  exit 1
fi

# ====Teardown=====================================================================================
popd >/dev/null || exit 1


