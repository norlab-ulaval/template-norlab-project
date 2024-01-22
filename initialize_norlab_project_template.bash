#!/bin/bash
# =================================================================================================
# Configure this norlab project template
#
# Usage in a interactive terminal session:
#
#   $ cd <path/to/your/new/norlab/project/root/>
#   $ bash initialize_norlab_project_template.bash
#
# =================================================================================================
set -e            # exit on error
set -o pipefail   # exit if errors within pipes

MSG_DIMMED_FORMAT="\033[1;2m"
MSG_ERROR_FORMAT="\033[1;31m"
MSG_END_FORMAT="\033[0m"


function tnp::install_norlab_project_template(){
  local INPUT
  local INSTALL_N2ST

  # ....Pre-condition..............................................................................
  if [[ ! -f  "README.norlab_template.md" ]]; then
    echo -e "${MSG_ERROR_FORMAT}[ERROR]${MSG_END_FORMAT} 'initialize_norlab_project_template.bash' script should be executed from the project root!\n Current working directory is '$(pwd)'" 1>&2
    exit 1
  fi

  # Note: can handle both sourcing cases
  #   i.e. from within a script or from an interactive terminal session
  _PATH_TO_SCRIPT="$(realpath "${BASH_SOURCE[0]:-'.'}")"
  TNP_ROOT="$(dirname "${_PATH_TO_SCRIPT}")"

  # ....Load environment variables from file.......................................................
  cd "${TNP_ROOT}" || exit 1
  set -o allexport
  source .env.template-norlab-project.template
  set +o allexport

  local NEW_PROJECT_GIT_NAME=${PROJECT_GIT_NAME}

  # ....Source NorLab Project Template dependencies................................................

  # . . Import N2ST lib . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
  cd "${N2ST_PATH:?"Variable not set"}" || exit 1
  source "import_norlab_shell_script_tools_lib.bash"

  # ====Begin======================================================================================

  n2st::norlab_splash "${PROJECT_PROMPT_NAME} 🦾"  https://github.com/norlab-ulaval/template-norlab-project

  n2st::print_formated_script_header 'initialize_norlab_project_template.bash' '='

  # ....Install NBS................................................................................
  {
    n2st::print_msg_awaiting_input "Do you want to install Norlab Build System (NBS) submodule?"
    echo
    TMP_MSG="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${TMP_MSG}" "\033[2m" " "
    echo
    unset INPUT
    read -n 1 -r -a INPUT
    echo "INPUT=$INPUT" # User input feedback

    cd "${TNP_ROOT}" || exit 1
    if [[ ${INPUT} == "Y" ]] || [[ ${INPUT} == "y" ]]; then
      n2st::print_msg "Installing NBS"

      git submodule \
        add https://github.com/norlab-ulaval/norlab-build-system.git \
        utilities/norlab-build-system

      # Traverse the submodule recursively to fetch any sub-submodule
      git submodule update --remote --recursive --init

      n2st::seek_and_modify_string_in_file "#NBS_PATH=" "NBS_PATH=" .env.template-norlab-project.template
      n2st::seek_and_modify_string_in_file "#NBS_SPLASH_NAME=" "NBS_SPLASH_NAME=" .env.template-norlab-project.template

      # Commit the submodule to your repository
      git add .gitmodules
      git add utilities/norlab-build-system
      git commit -m 'build: Added norlab-build-system submodule to repository'

    else
      n2st::print_msg "Skipping NBS install"
      n2st::seek_and_modify_string_in_file "#NBS_PATH=.*" " " .env.template-norlab-project.template
      n2st::seek_and_modify_string_in_file "#NBS_SPLASH_NAME=.*" " " .env.template-norlab-project.template

    fi
    echo
  }

  # ....Install N2ST...............................................................................
  {
    n2st::print_msg_awaiting_input "Do you want to install Norlab Shell Script Tools (N2ST) submodule?"
    echo
    TMP_MSG="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${TMP_MSG}" "\033[2m" " "
    echo
    unset INPUT
    read -n 1 -r -a INPUT
    echo "INPUT=$INPUT" # User input feedback

    INSTALL_N2ST=true

    if [[ ${INPUT} == "Y" ]] || [[ ${INPUT} == "y" ]]; then
      # Submodule is already pre-installed
      n2st::print_msg "Installing N2ST"
    else
      n2st::print_msg "Skipping N2ST install"
      INSTALL_N2ST=false
    fi
  }

  # ....Install Semantic-release...................................................................
  {
    n2st::print_msg_awaiting_input "Do you want to install Semantic-Release?"
    echo
    TMP_MSG="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${TMP_MSG}" "\033[2m" " "
    echo
    unset INPUT
    read -n 1 -r -a INPUT
    echo "INPUT=$INPUT" # User input feedback

    if [[ ${INPUT} == "Y" ]] || [[ ${INPUT} == "y" ]]; then
      # Submodule is already pre-installed
      n2st::print_msg "Installing Semantic-Release"

      n2st::print_msg "Resetting ${MSG_DIMMED_FORMAT}CHANGELOG.md${MSG_END_FORMAT}"
      cd "${TNP_ROOT}" || exit 1
      truncate --size=0 CHANGELOG.md

    else
      n2st::print_msg "Skipping Semantic-Release install"

      rm -R version.txt
      rm -R CHANGELOG.md
      rm -R .releaserc.json
      rm -R .github/workflows/semantic_release.yml

    fi
  }



  # ....Modify .env project environment variable prefix............................................
  {
    n2st::print_msg_awaiting_input "Choose a project wide environment variable prefix? (keep it short, two to four letters, alpha numeric only and no spacing)"
    echo
    TMP_MSG="(press 'return' when done) "
    n2st::echo_centering_str "${TMP_MSG}" "\033[2m" " "
    echo
    unset INPUT
    read -r -a INPUT
    echo "INPUT=$INPUT" # User input feedback
    echo

    # Capitalise new prefix
    INPUT="$(echo "${INPUT}" | tr '[:lower:]' '[:upper:]')"

    n2st::print_msg "Using environment variable prefix ${MSG_DIMMED_FORMAT}${INPUT}${MSG_END_FORMAT} e.g.: ${MSG_DIMMED_FORMAT}${INPUT}_PATH${MSG_END_FORMAT}"

    cd "${TNP_ROOT}" || exit 1
    n2st::seek_and_modify_string_in_file "PLACEHOLDER_" "${INPUT}_" .env.template-norlab-project.template
    n2st::seek_and_modify_string_in_file "PROJECT_PROMPT_NAME='Norlab-Project-Template'" "PROJECT_PROMPT_NAME='${INPUT}'" .env.template-norlab-project.template

    mv .env.template-norlab-project.template ".env.${NEW_PROJECT_GIT_NAME}"

  }

  # ....Set main readme file.......................................................................
  {
    n2st::print_msg_awaiting_input "Which readme file you want to use? NorLab (Default) or VAUL"
    echo
    TMP_MSG="(press 'V' to use VAUL, or press any other key to use NorLab) "
    n2st::echo_centering_str "${TMP_MSG}" "\033[2m" " "
    echo
    unset INPUT
    read -n 1 -r -a INPUT
    echo "INPUT=$INPUT" # User input feedback

    cd "${TNP_ROOT}" || exit 1
    if [[ ${INPUT} == "V" ]] || [[ ${INPUT} == "v" ]]; then

      n2st::print_msg "Setting up the VAUL README.md"
      mv README.md NORLAB_PROJECT_TEMPLATE_INSTRUCTIONS.md
      mv README.vaul_template.md README.md

    else

      n2st::print_msg "Setting up the NorLab README.md"
      mv README.md NORLAB_PROJECT_TEMPLATE_INSTRUCTIONS.md
      mv README.norlab_template.md README.md

    fi
  }

  # ....Commit project configuration steps.........................................................
  {
    n2st::print_msg "Commit changes"
    cd "${TNP_ROOT}" || exit 1
    git add .
    git commit -m 'refactor: NorLab project template configuration'
  }

  # ....Delayed N2ST deletion step.................................................................
  {
    cd "${TNP_ROOT}" || exit 1
    if [[ ${INSTALL_N2ST} == false ]]; then

      # Delete N2ST submodule
      git rm utilities/norlab-shell-script-tools

      n2st::seek_and_modify_string_in_file "N2ST_PATH=.*" " " ".env.${NEW_PROJECT_GIT_NAME}"
      rm -R tests/tests_bats
      rm -R tests/run_bats_core_test_in_n2st.bash
      rm -R ".run/runBatsTests_tests_all.run.xml"

      git commit -m 'build: Deleted norlab-shell-script-tools submodule from repository'

    fi
  }

  # ====Teardown===================================================================================
  {
    n2st::print_msg "Teardown clean-up"
    cd "${TNP_ROOT}" || exit 1
    rm "src/dummy.bash"
    if [[ -d tests/tests_bats ]]; then
      rm "tests/tests_bats/bats_testing_tools/norlab_project_template_helper_functions.bash"
      rm "tests/tests_bats/test_dotenv_files.bats"
      rm "tests/tests_bats/test_initialize_norlab_project_template.bats"
    fi
  }

  n2st::print_formated_script_footer 'initialize_norlab_project_template.bash' '='

  exit 0
  cd "${TNP_ROOT}" || exit 1
}

# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
  # This script is being run, ie: __name__="__main__"
  tnp::install_norlab_project_template
  exit 0
else
  # This script is being sourced, ie: __name__="__source__"
  echo -e "${MSG_ERROR_FORMAT}[ERROR]${MSG_END_FORMAT} This script must be run with bash i.e.: $ bash initialize_norlab_project_template.bash" 1>&2
  exit 1
fi

