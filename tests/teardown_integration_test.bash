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


function tnp::reset_mock_repository_github_config() {
  # Remove any branch protection rules that might have been added during testing
  # Note: This requires the repository to be accessible and the user to have admin rights

  if [[ -d "utilities/tmp/dockerized-norlab-project-mock-EMPTY" ]]; then
    echo "Resetting GitHub repository settings..."
    local tmp_cwd
    tmp_cwd=$(pwd)

    cd "${TNP_PATH:?err}/utilities/tmp/dockerized-norlab-project-mock-EMPTY" || return 1

    # ....Begin....................................................................................
    if command -v gh &> /dev/null && gh auth status &> /dev/null 2>&1; then
      echo "Removing test branch protection rules..."

      # Get repository info
      local repo_info
      local repo_owner
      local repo_name
      repo_info=$(gh repo view --json owner,name 2>/dev/null || echo '{"owner":{"login":""},"name":""}')
      repo_owner=$(echo "$repo_info" | jq -r '.owner.login')
      repo_name=$(echo "$repo_info" | jq -r '.name')

      if [[ -n "$repo_owner" && -n "$repo_name" && "$repo_owner" != "null" && "$repo_name" != "null" ]]; then
        # Remove protection from main and dev branches if they exist
        for branch in "main" "dev"; do
          if git show-ref --verify --quiet "refs/remotes/origin/$branch" 2>/dev/null; then
            echo "Removing protection from branch: $branch"
            gh api --method DELETE "/repos/$repo_owner/$repo_name/branches/$branch/protection" 2>/dev/null || echo "No protection to remove for $branch"
          fi
        done
      fi
    fi

  fi
  # ....Teardown...................................................................................
  cd "${tmp_cwd}" || return 1
  return 0
}


# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # This script is being run, ie: __name__="__main__"

  cd "${N2ST_PATH:?'Variable not set'}" || exit 1
  source "import_norlab_shell_script_tools_lib.bash" || exit 1

  tnp::reset_mock_repository_github_config

else
  # This script is being sourced, ie: __name__="__source__"
  tnp_error_prefix="\033[1;31m[TNP error]\033[0m"
  echo -e "${tnp_error_prefix} This script must executed with bash! i.e.: $ bash $( basename "$0" )" 1>&2
  exit 1
fi

# ====Teardown=====================================================================================
popd >/dev/null || exit 1


