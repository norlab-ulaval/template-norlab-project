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
fi

tnp_root=$(git rev-parse --show-toplevel)

bash "${tnp_root}/tests/tests_dryrun_and_tests_scripts/dryrun_configure_github_branch_protection.bash"
EXIT_CODE=$?

exit $EXIT_CODE
