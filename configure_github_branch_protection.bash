#!/bin/bash
DOCUMENTATION_CONFIGURE_GITHUB_BRANCH_PROTECTION=$( cat <<'EOF'
# =================================================================================================
# Configure GitHub branch protection rules for release, pre-release and bleeding edge branches
#
# Usage:
#   $ bash configure_github_branch_protection.bash [OPTIONS]
#
# Options:
#   --release-branch BRANCH_NAME     Set release branch name (default: main)
#   --dev-branch BRANCH_NAME         Set bleeding edge branch name (default: dev)
#   --branch BRANCH_NAME             Configure a specific branch only
#   --dry-run                        Show what would be done without making changes
#   --help                           Show this help message
#
# Notes:
#   - Require that the repository be hosted on GitHub
#   - Default branch name:
#     - Release branch: 'main'
#     - Pre-release branch: 'beta'
#     - Bleeding edge branch: 'dev'
#   - Branches will be created and push to remote if they don't exist
#
# =================================================================================================
EOF
)
set -e

# ====Dependencies=================================================================================
tnp_error_prefix="\033[1;31m[TNP error]\033[0m"
test -n "${N2ST_PATH}" || { echo -e "${tnp_error_prefix} The N2ST_PATH env var is not set!" 1>&2 && exit 1; }
source "${N2ST_PATH:?err}/import_norlab_shell_script_tools_lib.bash"

# ====Functions====================================================================================
function gbp::validate_prerequisites() {
    local repo_url

    # Check if gh CLI is installed
    if ! command -v jq &> /dev/null; then
        n2st::print_msg_error "Command-line JSON processor (jq) is not installed. Please install it first:"
        echo "  https://manpages.ubuntu.com/manpages/focal/man1/jq.1.html"
        return 1
    fi

    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        n2st::print_msg_error "GitHub CLI (gh) is not installed. Please install it first:"
        echo "  https://cli.github.com/"
        return 1
    fi

    # Check if authenticated
    if ! gh auth status &> /dev/null; then
        n2st::print_msg_error "GitHub CLI is not authenticated. Please run:"
        echo "  gh auth login"
        return 1
    fi

    # Check if current directory is a git repository
    if ! git rev-parse --git-dir &> /dev/null; then
        n2st::print_msg_error "Current directory is not a git repository"
        return 1
    fi

    # Check if repository is hosted on GitHub
    repo_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
    if [[ ! "$repo_url" =~ github\.com ]]; then
        n2st::print_msg_error "Repository is not hosted on GitHub"
        return 1
    fi

    return 0
}

function gbp::get_repository_info() {
    local repo_info
    repo_info=$(gh repo view --json owner,name)

    REPO_OWNER=$(echo "$repo_info" | jq -r '.owner.login')
    REPO_NAME=$(echo "$repo_info" | jq -r '.name')

    export REPO_OWNER
    export REPO_NAME
    n2st::print_msg "Repository: ${REPO_OWNER}/${REPO_NAME}"
}

function gbp::create_branch_if_not_exists() {
    local branch_name="$1"
    local dry_run="$2"

    # Check if branch exists locally or remotely
    if git show-ref --verify --quiet "refs/heads/$branch_name" || \
      git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
        n2st::print_msg "Branch '$branch_name' already exists"
        return 0
    fi

    if [[ "$dry_run" == "true" ]]; then
        n2st::print_msg "DRY RUN: Would create branch '$branch_name'"
        return 0
    fi

    n2st::print_msg "Creating branch '$branch_name'..."

    # Create branch from current HEAD and push to remote
    if git checkout -b "$branch_name" && git push -u origin "$branch_name"; then
        n2st::print_msg_done "Branch '$branch_name' created and pushed to remote"
        # Switch back to original branch
        git checkout -
    else
        n2st::print_msg_error "Failed to create branch '$branch_name'"
        return 1
    fi
}

function gbp::configure_branch_protection() {
    local branch_name="$1"
    local dry_run="$2"
    local protection_config

    n2st::print_msg "Configuring branch protection for: ${branch_name}"

    # Build protection configuration
    protection_config=$(cat <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": [${GBP_CI_CHECKS}]
  },
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "require_last_push_approval": false
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true
}
EOF
    )

    if [[ "$dry_run" == "true" ]]; then
        n2st::print_msg "DRY RUN: Would configure ${branch_name} with:"
        echo "$protection_config" | jq '.'
        return 0
    fi

    # Apply protection rule
    if gh api \
        --method PUT \
        --header "Accept: application/vnd.github+json" \
        "/repos/${REPO_OWNER:?err}/${REPO_NAME:?err}/branches/${branch_name}/protection" \
        --input <(echo "$protection_config") > /dev/null; then
        n2st::print_msg_done "Branch protection configured for: ${branch_name}"
    else
        n2st::print_msg_error "Failed to configure branch protection for: ${branch_name}"
        return 1
    fi
}

function gbp::status_check_configuration() {
    local user_input

    n2st::print_msg_awaiting_input "Configure CI status checks? (y/N)"
    read -n 1 -r user_input

    if [[ "${user_input}" == "y" || "${user_input}" == "Y" ]]; then
        n2st::print_msg_awaiting_input "Enter CI check names (comma-separated, e.g., 'ci/tests,ci/build'):"
        read -r ci_checks
        echo "${ci_checks}"
    fi
}

function gbp::update_releaserc_json() {
    local release_branch="$1"
    local dry_run="$2"

    # Check if .releaserc.json exists
    if [[ ! -f ".releaserc.json" ]]; then
        n2st::print_msg_warning ".releaserc.json not found, skipping semantic-release configuration update"
        return 0
    fi

    # Only update if using non-default release branch name
    if [[ "$release_branch" == "main" ]]; then
        n2st::print_msg "Using default release branch name, no .releaserc.json update needed"
        return 0
    fi

    n2st::print_msg "Updating .releaserc.json with custom release branch name..."

    if [[ "$dry_run" == "true" ]]; then
        n2st::print_msg "DRY RUN: Would update .releaserc.json:"
        echo "  - Release branch: $release_branch"
        return 0
    fi

    # Create backup
    cp .releaserc.json .releaserc.json.backup

    # Update the branches configuration using jq
    local updated_config
    updated_config=$(jq --arg release_branch "$release_branch" '
        .branches[0] = $release_branch
    ' .releaserc.json)

    if [[ $? -eq 0 ]]; then
        echo "$updated_config" > .releaserc.json
        n2st::print_msg_done ".releaserc.json updated successfully"
        echo "Backup saved as .releaserc.json.backup"
    else
        n2st::print_msg_error "Failed to update .releaserc.json"
        # Restore backup
        mv .releaserc.json.backup .releaserc.json
        return 1
    fi
}

function gbp::update_semantic_release_yml() {
    local release_branch="$1"
    local dry_run="$2"

    # Check if semantic_release.yml exists
    if [[ ! -f ".github/workflows/semantic_release.yml" ]]; then
        n2st::print_msg_warning ".github/workflows/semantic_release.yml not found, skipping workflow update"
        return 0
    fi

    # Only update if using non-default release branch name
    if [[ "$release_branch" == "main" ]]; then
        n2st::print_msg "Using default release branch name, no semantic_release.yml update needed"
        return 0
    fi

    n2st::print_msg "Updating semantic_release.yml with custom release branch name..."

    if [[ "$dry_run" == "true" ]]; then
        n2st::print_msg "DRY RUN: Would update .github/workflows/semantic_release.yml:"
        echo "  - Release branch: $release_branch"
        return 0
    fi

    # Create backup
    cp .github/workflows/semantic_release.yml .github/workflows/semantic_release.yml.backup

    # Update the branches configuration using sed
    if sed -i.tmp "s/- main/- $release_branch/g" .github/workflows/semantic_release.yml; then
        rm -f .github/workflows/semantic_release.yml.tmp
        n2st::print_msg_done "semantic_release.yml updated successfully"
        echo "Backup saved as .github/workflows/semantic_release.yml.backup"
    else
        n2st::print_msg_error "Failed to update semantic_release.yml"
        # Restore backup
        mv .github/workflows/semantic_release.yml.backup .github/workflows/semantic_release.yml
        return 1
    fi
}

function gbp::show_help() {
  # (NICE TO HAVE) ToDo: refactor as a n2st fct (ref NMO-583)
  echo -e "${MSG_DIMMED_FORMAT}"
  n2st::draw_horizontal_line_across_the_terminal_window "="
  echo -e "$0 --help\n"
  # Strip shell comment char `#` and both lines
  echo -e "${DOCUMENTATION_CONFIGURE_GITHUB_BRANCH_PROTECTION}" | sed '/\# ====.*/d' | sed 's/^\# //' | sed 's/^\#//'
  n2st::draw_horizontal_line_across_the_terminal_window "="
  echo -e "${MSG_END_FORMAT}"
}

function gbp::main() {
    local dry_run="false"
    local arbitrary_branch=""
    local release_branch="main"
    local pre_release_branch="beta"
    local dev_branch="dev"

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                dry_run="true"
                shift
                ;;
            --branch)
                arbitrary_branch="$2"
                shift 2
                ;;
            --release-branch)
                release_branch="$2"
                shift 2
                ;;
            --dev-branch)
                dev_branch="$2"
                shift 2
                ;;
            --help)
                gbp::show_help
                return 0
                ;;
            *)
                n2st::print_msg_error "Unknown option: $1"
                gbp::show_help
                return 1
                ;;
        esac
    done

    ## Print header
    #n2st::norlab_splash "GitHub Branch Protection" "https://github.com/norlab-ulaval/template-norlab-project"
    #n2st::print_formated_script_header "$( basename $0)" "="

    # Validate prerequisites
    gbp::validate_prerequisites || return 1

    # Get repository information
    gbp::get_repository_info
    test -n "${REPO_OWNER:?err}" || n2st::print_msg_error_and_exit "Env variable REPO_OWNER need to be set and non-empty."
    test -n "${REPO_NAME:?err}" || n2st::print_msg_error_and_exit "Env variable REPO_NAME need to be set and non-empty."

    if [[ "$dry_run" == "false" ]]; then
        # Interactive configuration if not dry run
        GBP_CI_CHECKS=$( gbp::status_check_configuration )
        export GBP_CI_CHECKS
    else
        n2st::print_msg "DRY RUN: Would set GBP_CI_CHECKS env var"
    fi

    # Update .releaserc.json if using non-default release branch name
    gbp::update_releaserc_json "$release_branch" "$dry_run"

    # Update semantic_release.yml if using non-default release branch name
    gbp::update_semantic_release_yml "$release_branch" "$dry_run"

    # Configure branches
    if [[ -n "$arbitrary_branch" ]]; then
        # Create branch if it doesn't exist
        gbp::create_branch_if_not_exists "$arbitrary_branch" "$dry_run"
        gbp::configure_branch_protection "$arbitrary_branch" "$dry_run"
    else
        # Configure release and dev branches
        for branch in "$release_branch" "$pre_release_branch" "$dev_branch"; do
            n2st::print_msg "Processing branch: $branch"
            # Create branch if it doesn't exist
            gbp::create_branch_if_not_exists "$branch" "$dry_run"
            # Configure protection
            gbp::configure_branch_protection "$branch" "$dry_run"
        done

        # Set the default branch name
        if [[ "$dry_run" == "false" ]]; then
          gh repo edit --default-branch "$release_branch"
        else
          n2st::print_msg "DRY RUN: Would set repository default branch to '$release_branch'"
        fi
    fi

    n2st::print_msg_done "Branch protection configuration completed"
    #n2st::print_formated_script_footer "$( basename $0)" "="
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    gbp::main "$@"
fi
