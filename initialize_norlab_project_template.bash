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
  local user_input
  local install_n2st
  local tmp_msg


  # ....Pre-condition..............................................................................
  if [[ ! -f  "README.norlab_template.md" ]]; then
    echo -e "${MSG_ERROR_FORMAT}[ERROR]${MSG_END_FORMAT} 'initialize_norlab_project_template.bash' script should be executed from the project root!\n Current working directory is '$(pwd)'" 1>&2
    return 1
  fi

  local script_path
  local tmp_root
  script_path="$(realpath -q "${BASH_SOURCE[0]:-.}")"
  tmp_root="$(dirname "${script_path}")"

  # ....Load environment variables from file.......................................................
  cd "${tmp_root}" || return 1
  set -o allexport
  source .env.template-norlab-project.template
  set +o allexport

  local new_project_git_name=${PROJECT_GIT_NAME:?err}

  # ....Source NorLab Project Template dependencies................................................

  # . . Import N2ST lib . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
  cd "${N2ST_PATH:?"Variable not set"}" || return 1
  source "import_norlab_shell_script_tools_lib.bash"

  # ====Begin======================================================================================

  n2st::norlab_splash "Norlab-Project-Template 🦾"  https://github.com/norlab-ulaval/template-norlab-project

  n2st::print_formated_script_header 'initialize_norlab_project_template.bash' '='

  # ....Install NBS................................................................................
  {
    n2st::print_msg_awaiting_input "Do you want to install Norlab Build System (NBS) submodule?"
    echo
    tmp_msg="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${tmp_msg}" "\033[2m" " "
    echo
    unset user_input
    read -n 1 -r user_input
#    echo "user_input=$user_input" # User user_input feedback
    echo

    cd "${tmp_root}" || return 1
    if [[ "${user_input}" == "Y" ]] || [[ "${user_input}" == "y" ]]; then
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
      git add .env.template-norlab-project.template
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
    tmp_msg="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${tmp_msg}" "\033[2m" " "
    echo
    unset user_input
    read -n 1 -r user_input
#    echo "user_input=$user_input" # User user_input feedback
    echo

    install_n2st=true

    cd "${tmp_root}" || return 1
    if [[ "${user_input}" == "Y" ]] || [[ "${user_input}" == "y" ]]; then
      # Submodule is already pre-installed
      n2st::print_msg "Installing N2ST"

      mv tests/run_bats_core_test_in_n2st.template.bash tests/run_bats_core_test_in_n2st.bash

      n2st::seek_and_modify_string_in_file "Execute 'template-norlab-project.template' repo" "Execute '${new_project_git_name}' repo" tests/run_bats_core_test_in_n2st.bash
      n2st::seek_and_modify_string_in_file "source .env.template-norlab-project.template.*" "source .env.${new_project_git_name}" tests/run_bats_core_test_in_n2st.bash

    else
      n2st::print_msg "Skipping N2ST install"
      install_n2st=false
    fi
  }

  # ....Install Semantic-release...................................................................
  {
    n2st::print_msg_awaiting_input "Do you want to install Semantic-Release?"
    echo
    tmp_msg="(press 'Y' to install, or press any other key to skip) "
    n2st::echo_centering_str "${tmp_msg}" "\033[2m" " "
    echo
    unset user_input
    read -n 1 -r user_input
#    echo "user_input=$user_input" # User user_input feedback
    echo

    if [[ "${user_input}" == "Y" ]] || [[ "${user_input}" == "y" ]]; then
      # Submodule is already pre-installed
      n2st::print_msg "Installing Semantic-Release"

      n2st::print_msg "Resetting ${MSG_DIMMED_FORMAT}CHANGELOG.md${MSG_END_FORMAT}"
      cd "${tmp_root}" || return 1
      truncate --size=0 CHANGELOG.md

    else
      n2st::print_msg "Skipping Semantic-Release install"

      rm -R version.txt
      rm -R CHANGELOG.md
      rm -R .releaserc.json
      rm -R .github/workflows/semantic_release.yml

    fi
  }


  # ....Modify project prefix......................................................................

  {
    n2st::print_msg_awaiting_input "Choose a project wide environment variable prefix? (keep it short, two to four letters, alpha numeric only and no spacing)"
    echo
    tmp_msg="(press 'return' when done) "
    n2st::echo_centering_str "${tmp_msg}" "\033[2m" " "
    echo
    unset user_input
    read -r user_input
    # echo "user_input=$user_input" # User user_input feedback
    echo

    # Capitalise new prefix
    local env_prefix
    local fct_prefix
    env_prefix="$(echo "${user_input}" | tr '[:lower:]' '[:upper:]')"
    fct_prefix="$(echo "${user_input}" | tr '[:upper:]' '[:lower:]')"

    n2st::print_msg "Using environment variable prefix ${MSG_DIMMED_FORMAT}${env_prefix}${MSG_END_FORMAT} e.g.: ${MSG_DIMMED_FORMAT}${env_prefix}_PATH${MSG_END_FORMAT}"

    cd "${tmp_root}" || return 1
    n2st::seek_and_modify_string_in_file "PLACEHOLDER_" "${env_prefix}_" .env.template-norlab-project.template
    n2st::seek_and_modify_string_in_file "PROJECT_PROMPT_NAME=Norlab-Project-Template" "PROJECT_PROMPT_NAME=${env_prefix}" .env.template-norlab-project.template

    mv .env.template-norlab-project.template ".env.${new_project_git_name}"


    n2st::seek_and_modify_string_in_file "folderName=\"\[TNP\]" "folderName=\"\[${env_prefix}\]" .run/open-a-terminal-in-ubuntu-container.run.xml
    n2st::seek_and_modify_string_in_file "folderName=\"\[TNP\]" "folderName=\"\[${env_prefix}\]" .run/run-Bats-Tests-All.run.xml

    n2st::seek_and_modify_string_in_file "tests/run_bats_core_test_in_n2st.tnp.bash" "tests/run_bats_core_test_in_n2st.bash" .run/run-Bats-Tests-All.run.xml

    if [[ ${install_n2st} == true ]]; then
      n2st::seek_and_modify_string_in_file "function n2st::" "function ${fct_prefix}::" src/dummy.bash
      n2st::seek_and_modify_string_in_file "n2st::" "${fct_prefix}::" tests/tests_bats/test_template.bats
      n2st::seek_and_modify_string_in_file "TNP_" "${env_prefix}_" tests/run_bats_core_test_in_n2st.bash
    fi

  }

  # ....Update CODEOWNER file......................................................................
  local git_user_name
  git_user_name="$(git config user.name)"
  echo ">>>> ${git_user_name}"

  {
    cd "${tmp_root}/.github" || return 1
    n2st::seek_and_modify_string_in_file "TNP_GIT_USER_NAME_PLACEHOLDER" "${git_user_name:-'TODO-CHANGE-GIT-NAME'}" CODEOWNERS
  }

  # ....Set main readme file.......................................................................

  {
    n2st::print_msg_awaiting_input "Which readme file you want to use? NorLab (Default) or VAUL"
    echo
    tmp_msg="(press 'V' to use VAUL, or press any other key to use NorLab) "
    n2st::echo_centering_str "${tmp_msg}" "\033[2m" " "
    echo
    unset user_input
    read -n 1 -r user_input
#    echo "user_input=$user_input" # User user_input feedback
    echo

    cd "${tmp_root}" || return 1
    if [[ ${user_input} == "V" ]] || [[ ${user_input} == "v" ]]; then

      n2st::print_msg "Setting up the VAUL README.md"
      mv README.md "${tmp_root}/to_delete/NORLAB_PROJECT_TEMPLATE_INSTRUCTIONS.md"
      mv README.vaul_template.md README.md

      n2st::seek_and_modify_string_in_file "img.shields.io/github/v/release/vaul-ulaval/template-norlab-project" "img.shields.io/github/v/release/vaul-ulaval/${new_project_git_name}" README.md
      n2st::seek_and_modify_string_in_file "vaul-ulaval/template-norlab-project.git" "vaul-ulaval/${new_project_git_name}.git" README.md

      rm README.norlab_template.md

    else

      n2st::print_msg "Setting up the NorLab README.md"
      mv README.md "${tmp_root}/to_delete/NORLAB_PROJECT_TEMPLATE_INSTRUCTIONS.md"
      mv README.norlab_template.md README.md

      n2st::seek_and_modify_string_in_file "img.shields.io/github/v/release/norlab-ulaval/template-norlab-project" "img.shields.io/github/v/release/norlab-ulaval/${new_project_git_name}" README.md
      n2st::seek_and_modify_string_in_file "norlab-ulaval/template-norlab-project.git" "norlab-ulaval/${new_project_git_name}.git" README.md

      rm README.vaul_template.md

    fi

    n2st::seek_and_modify_string_in_file "https://github.com/TNP_GIT_USER_NAME_PLACEHOLDER\">TNP_GIT_USER_NAME_PLACEHOLDER" "https://github.com/${git_user_name:-'TODO-CHANGE-MAINTAINER'}\">${git_user_name:-'TODO-CHANGE-MAINTAINER'}*" README.md
    n2st::seek_and_modify_string_in_file "TNP_PROJECT_NAME_PLACEHOLDER" "${new_project_git_name}" README.md

  }



  # ....Commit project configuration steps.........................................................
  {
    n2st::print_msg "Commit project configuration changes"
    cd "${tmp_root}" || return 1
    git add .
    git commit -m 'refactor: NorLab project template configuration'
  }

  # ....Delayed N2ST deletion step.................................................................
  {
    cd "${tmp_root}" || return 1
    if [[ ${install_n2st} == false ]]; then

      # Delete N2ST submodule
      git rm utilities/norlab-shell-script-tools

      if [[ ! -d utilities/norlab-build-system ]]; then
        rm -R ".env.${new_project_git_name}"
      else
        n2st::seek_and_modify_string_in_file "N2ST_PATH=.*" " " ".env.${new_project_git_name}"
      fi

      rm -R src/dummy.bash
      rm -R tests/tests_bats
      rm -R tests/run_bats_core_test_in_n2st.template.bash
      rm -R ".run/run-Bats-Tests-All.run.xml"

      n2st::print_msg "Commit N2ST lib deletion"
      git add src/dummy.bash
      if [[ ! -d utilities/norlab-build-system ]]; then
        git add ".env.${new_project_git_name}"
      fi
      git add tests/tests_bats
      git add tests/run_bats_core_test_in_n2st.template.bash
      git add ".run/run-Bats-Tests-All.run.xml"
      git commit -m 'build: Deleted norlab-shell-script-tools submodule from repository'

    fi
  }

  # ====Teardown===================================================================================
  {
    n2st::print_msg "Teardown clean-up"
    cd "${tmp_root}" || return 1
    mv initialize_norlab_project_template.bash "${tmp_root}/to_delete/initialize_norlab_project_template.bash"

    if [[ -d tests/tests_bats ]]; then
      rm "tests/tests_bats/bats_testing_tools/norlab_project_template_helper_functions.bash"
      rm "tests/tests_bats/test_dotenv_files.bats"
      rm "tests/tests_bats/test_initialize_norlab_project_template.bats"
      git add "tests/tests_bats/bats_testing_tools/norlab_project_template_helper_functions.bash"
      git add "tests/tests_bats/test_dotenv_files.bats"
      git add "tests/tests_bats/test_initialize_norlab_project_template.bats"
    fi

    rm -R tests/run_bats_core_test_in_n2st.tnp.bash
    git add tests/run_bats_core_test_in_n2st.tnp.bash

    n2st::print_msg "Commit template-norlab-project files/dir clean-up"
    git commit -m 'build: Clean-up template-norlab-project from repository'

  }

  n2st::print_msg_done "You can delete the ${MSG_DIMMED_FORMAT}to_delete/${MSG_END_FORMAT} directory whenever you are ready.

   NorLab project remaining configuration steps:
   - ${MSG_DONE_FORMAT}✔ Step 1 › Generate the new repository${MSG_END_FORMAT}
   - ${MSG_DONE_FORMAT}✔ Step 2 › Execute initialize_norlab_project_template.bash${MSG_END_FORMAT}
   -   Step 3 › Make it your own
       https://github.com/norlab-ulaval/template-norlab-project/tree/main#step-3--make-it-your-own
   -   Step 4 › Configure the GitHub repository settings
       https://github.com/norlab-ulaval/template-norlab-project/tree/main#step-4--configure-the-github-repository-settings
   -   Step 5 › Release automation: enable semantic versioning tools
       https://github.com/norlab-ulaval/template-norlab-project/tree/main#step-5--enable-release-automation-tools-semantic-versioning

Happy coding!"
  n2st::print_formated_script_footer 'initialize_norlab_project_template.bash' '='

  cd "${tmp_root}" || return 1
  return 0
}

# ::::Main:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # This script is being run, ie: __name__="__main__"
  tnp::install_norlab_project_template
  exit $?
else
  # This script is being sourced, ie: __name__="__source__"
  echo -e "${MSG_ERROR_FORMAT}[ERROR]${MSG_END_FORMAT} This script must be run with bash i.e.: $ bash initialize_norlab_project_template.bash" 1>&2
  exit 1
fi

