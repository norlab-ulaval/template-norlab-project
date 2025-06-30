#!/bin/bash
# ================================================================================================
# Setup integration test
#
# Usage:
#   $ bash setup_integration_test.bash
#
# Global:
#   read TEAMCITY_VERSION
#   read GITHUB_TOKEN
#   read N2ST_PATH
#
# =================================================================================================
pushd "$(pwd)" >/dev/null || exit 1

function tnp::setup_mock_semantic_release_files() {
  n2st::print_formated_script_header "setup_integration_test.bash" "${MSG_LINE_CHAR_UTIL}"

  local tnp_mock_repo_path="${TNP_PATH:?err}/utilities/tmp/dockerized-norlab-project-mock-EMPTY"
  test -d "${tnp_mock_repo_path}" || n2st::print_msg_error_and_exit "The directory ${tnp_mock_repo_path} is unreachable"
  # Create a mock semantic_release.yml file
  mkdir -p "${tnp_mock_repo_path}/.github/workflows" || return 1
  cat > "${tnp_mock_repo_path}/.github/workflows/semantic_release.yml" << 'EOF'
name: Semantic-release

on:
  push:
    branches:
      - main
      - beta
      - alpha
EOF

  # Create a mock .releaserc.json file
  cat > "${tnp_mock_repo_path}/.releaserc.json" << 'EOF'
{
  "branches": ["main",
    {
      "name": "beta",
      "prerelease": true
    },
    {
      "name": "alpha",
      "prerelease": true
    }
  ]
}
EOF

  n2st::print_formated_script_footer "setup_integration_test.bash" "${MSG_LINE_CHAR_UTIL}"
  return 0
}

# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # This script is being run, ie: __name__="__main__"

  cd "${N2ST_PATH:?'Variable not set'}" || exit 1
  source "import_norlab_shell_script_tools_lib.bash" || exit 1
  tnp::setup_mock_semantic_release_files || exit 1

else
  # This script is being sourced, ie: __name__="__source__"
  tnp_error_prefix="\033[1;31m[TNP error]\033[0m"
  echo -e "${tnp_error_prefix} This script must executed with bash! i.e.: $ bash $( basename "$0" )" 1>&2
  exit 1
fi

# ====Teardown=====================================================================================
popd >/dev/null || exit 1
