
# ====Docker related===============================================================================

function mock_docker_command_exit_ok() {
    function docker() {
      local tmp=$@
      return 0
    }
}

function mock_docker_command_exit_error() {
    function docker() {
      local tmp=$@
      echo "Error" 1>&2
      return 1
    }
}

function mock_docker_command_config_services() {
    function docker() {
      local tmp=$@
      echo "mock-service-one mock-service-two"
      return 0
    }
}

# ====bats-file utility============================================================================

# Temporary workaround for missing implementation of "assert_file_not_contains"
# ToDo: remove when bats-file PR #61 is merge
#   - PR #61 at https://github.com/bats-core/bats-file/pull/61
#
# Credit https://github.com/bats-core/bats-file/pull/61
#
# Fail and display path of the file (or directory) if it does contain a string.
# This function is the logical complement of `assert_file_contains'.
#
# Globals:
#   BATSLIB_FILE_PATH_REM
#   BATSLIB_FILE_PATH_ADD
# Arguments:
#   $1 - path
#   $2 - regex
# Returns:
#   0 - file does not contain regex
#   1 - otherwise
# Outputs:
#   STDERR - details, on failure
assert_file_not_contains() {
  local -r file="$1"
  local -r regex="$2"

  if [[ ! -f "$file" ]]; then
    local -r rem="${BATSLIB_FILE_PATH_REM-}"
    local -r add="${BATSLIB_FILE_PATH_ADD-}"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" 'regex' "$regex" \
      | batslib_decorate 'file does not exist' \
      | fail

  elif grep -q "$regex" "$file"; then
    local -r rem="${BATSLIB_FILE_PATH_REM-}"
    local -r add="${BATSLIB_FILE_PATH_ADD-}"
    batslib_print_kv_single 4 'path' "${file/$rem/$add}" 'regex' "$regex" \
      | batslib_decorate 'file contains regex' \
      | fail

  fi
}

# ====Norlab Project Template======================================================================

function norlab_project_template_directory_reset_check() {

    # ....Check project root directories...........................................................
    assert_dir_exist "/code/template-norlab-project"
    assert_dir_exist "${TEST_TEMP_DIR}/template-norlab-project"
    assert_equal $(pwd) "${TEST_TEMP_DIR}/template-norlab-project"

    # ....Check git related........................................................................
    assert_dir_exist .git
    assert_file_exist .gitmodules
    assert_file_exist .gitignore
    assert_file_exist commit_msg_reference.md
    assert_file_exist .github/CODEOWNERS
    assert_file_exist .github/pull_request_template.md

    # ....Check readme files.......................................................................
    assert_file_exist README.md
    assert_file_exist README.norlab_template.md
    assert_file_exist README.vaul_template.md

    # ....Check semantic-release related...........................................................
    assert_file_exist version.txt
    assert_file_exist CHANGELOG.md
    assert_file_exist .releaserc.json
    assert_file_exist .github/workflows/semantic_release.yml

    # ....Check tests directory....................................................................
    assert_dir_exist tests/tests_bats/bats_testing_tools
    assert_file_exist tests/run_bats_core_test_in_n2st.bash

    # ....Check N2ST related.......................................................................
    assert_dir_exist utilities/norlab-shell-script-tools
    assert_file_contains .gitmodules "\[submodule \"utilities/norlab-shell-script-tools\"\]"
    assert_file_contains .gitmodules .*"url = https://github.com/norlab-ulaval/norlab-shell-script-tools.git"

    # ....Check NBS related........................................................................
    assert_dir_not_exist utilities/norlab-build-system
    assert_file_not_contains .gitmodules "\[submodule \"utilities/norlab-build-system\"\]"
    assert_file_not_contains .gitmodules "url = https://github.com/norlab-ulaval/norlab-build-system.git"

    # ....Check NorLab project template logic related..............................................
    assert_file_exist initialize_norlab_project_template.bash
    assert_file_exist .env.template-norlab-project.template

    # ....Check dotenv content.....................................................................
    assert_file_contains .env.template-norlab-project.template "^PROJECT_PROMPT_NAME='Norlab-Project-Template'"
    assert_file_contains .env.template-norlab-project.template "^#NBS_SPLASH_NAME=.*"
    assert_file_contains .env.template-norlab-project.template "^N2ST_PATH=\${PROJECT_PATH}/utilities/norlab-shell-script-tools"
    assert_file_contains .env.template-norlab-project.template "^#NBS_PATH=\${PROJECT_PATH}/utilities/norlab-build-system"
    assert_file_contains .env.template-norlab-project.template "^PLACEHOLDER_PROMPT_NAME.*"
    assert_file_contains .env.template-norlab-project.template "^PLACEHOLDER_GIT_REMOTE_URL.*"
    assert_file_contains .env.template-norlab-project.template "^PLACEHOLDER_GIT_NAME.*"
    assert_file_contains .env.template-norlab-project.template "^PLACEHOLDER_PATH.*"
    assert_file_contains .env.template-norlab-project.template "^PLACEHOLDER_SRC_NAME.*"
    assert_file_contains .env.template-norlab-project.template "^PROJECT_PROMPT_NAME='Norlab-Project-Template'"
}

function check_NBS_is_installed() {
    cd "${BATS_DOCKER_WORKDIR}" || exit 1
    assert_output --regexp .*"\[Norlab-Project-Template\]".*"Installing NBS"
    assert_dir_exist utilities/norlab-build-system
    assert_file_contains .env.template-norlab-project "^NBS_PATH=\${PROJECT_PATH}/utilities/norlab-build-system"
    assert_file_contains .env.template-norlab-project "^NBS_SPLASH_NAME=.*"
}

function check_NBS_not_installed() {
  cd "${BATS_DOCKER_WORKDIR}" || exit 1
  assert_output --regexp .*"\[Norlab-Project-Template\]".*"Skipping NBS install"
  assert_dir_not_exist utilities/norlab-build-system
  assert_file_not_contains .env.template-norlab-project "^#NBS_PATH=\${PROJECT_PATH}/utilities/norlab-build-system"
  assert_file_not_contains .env.template-norlab-project "^NBS_PATH=\${PROJECT_PATH}/utilities/norlab-build-system"
  assert_file_not_contains .env.template-norlab-project "^NBS_SPLASH_NAME=.*"
}

function check_N2ST_is_installed() {
  cd "${BATS_DOCKER_WORKDIR}" || exit 1
  assert_output --regexp .*"\[Norlab-Project-Template\]".*"Installing N2ST"
  assert_dir_exist utilities/norlab-shell-script-tools
  assert_file_contains .env.template-norlab-project "^N2ST_PATH=\${PROJECT_PATH}/utilities/norlab-shell-script-tools"
}

function check_N2ST_not_installed() {
  cd "${BATS_DOCKER_WORKDIR}" || exit 1
  assert_output --regexp .*"\[Norlab-Project-Template\]".*"Skipping N2ST install"
  assert_dir_not_exist utilities/norlab-shell-script-tools
  assert_file_not_contains .env.template-norlab-project "^N2ST_PATH=\${PROJECT_PATH}/utilities/norlab-shell-script-tools"

  assert_dir_not_exist tests/tests_bats
  assert_file_not_exist tests/run_bats_core_test_in_n2st.bash
}

function check_semantic_release_is_installed() {
  cd "${BATS_DOCKER_WORKDIR}" || exit 1
  assert_output --regexp .*"\[Norlab-Project-Template\]".*"Installing Semantic-Release"
  assert_file_exist version.txt
  assert_file_exist .releaserc.json
  assert_file_exist .github/workflows/semantic_release.yml
  assert_file_exist CHANGELOG.md

  assert_file_empty CHANGELOG.md
}

function check_semantic_release_not_installed() {
  assert_output --regexp .*"\[Norlab-Project-Template\]".*"Skipping Semantic-Release install"
  cd "${BATS_DOCKER_WORKDIR}" || exit 1
  assert_file_not_exist version.txt
  assert_file_not_exist CHANGELOG.md
  assert_file_not_exist .releaserc.json
  assert_file_not_exist .github/workflows/semantic_release.yml
}
