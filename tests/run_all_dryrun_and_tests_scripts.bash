#!/bin/bash
# =================================================================================================
# Run all tests script in tests_dryrun_and_tests_scripts
#
# Usage:
#   $ bash run_all_dryrun_and_tests_scripts.bash
#
# =================================================================================================

if [[ ${TEAMCITY_VERSION} ]]; then
  # Assuming is run in a TC docker run wrapper
  apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
        locales \
        sudo \
        lsb-release \
        curl \
        wget \
        ca-certificates \
        git \
        tree \
        zip gzip tar unzip \
        fontconfig \
        software-properties-common \
    && rm -rf /var/lib/apt/lists/*

  locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

  # This is required in our case since we deal with git submodule
  git config --global --add safe.directory "*"

fi

tnp_root=$(git rev-parse --show-toplevel)

bash "${tnp_root}/tests/tests_dryrun_and_tests_scripts/dryrun_configure_github_branch_protection.bash"
EXIT_CODE=$?

exit $EXIT_CODE
