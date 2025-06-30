#!/bin/bash

function tnp::install_gh_cli_on_ci() {
  # Official doc: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

  if [[ ${TEAMCITY_VERSION} ]] && [[ -z ${GITHUB_TOKEN} ]]; then
    n2st::print_msg_error_and_exit "CI execution require that GITHUB_TOKEN be set to enable automatic GitHub cli authentification login"
  fi

  if [[ $(uname) == "Linux" ]] && ! command -v gh &> /dev/null; then
    echo "Test is run on a TeamCity server, install GitHub cli"
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
      && sudo mkdir -p -m 755 /etc/apt/keyrings \
            && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
            && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
      && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
      && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
      && sudo apt update \
      && sudo apt install gh -y
  fi
}

function tnp::reset_mock_repository_github_config() {
  # Remove any branch protection rules that might have been added during testing
  # Note: This requires the repository to be accessible and the user to have admin rights

  local tnp_mock_repo_path="${TNP_PATH:?err}/utilities/tmp/dockerized-norlab-project-mock-EMPTY"

  if [[ -d "${tnp_mock_repo_path}" ]]; then
    echo "Resetting GitHub repository settings..."
    local tmp_cwd
    tmp_cwd=$(pwd)

    cd "${tnp_mock_repo_path}" || return 1

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
        local branches_name=("main" "dev")
        for branch in "${branches_name[@]}"; do
          echo "Check branch: ${branch}"
          if git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
            echo "Removing protection from branch: ${branch}"
            gh api --silent --method DELETE "/repos/$repo_owner/$repo_name/branches/${branch}/protection" 2>/dev/null || echo "No protection to remove for ${branch}"
          else
            echo "No branch ${branch}"
          fi
        done
      fi
    fi

  fi
  # ....Teardown...................................................................................
  cd "${tmp_cwd}" || return 1
  return 0
}
