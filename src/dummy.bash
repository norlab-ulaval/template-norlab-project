#!/bin/bash
# =================================================================================================
#
# This is script is used by tests/tests_bats/test_template.bats as a test case example.
# It can be deleted as long as test_template.bats does not refer to it.
# See TESTED_FILE="dummy.bash" near line 29.
#
# =================================================================================================

function n2st::talk_to_me_or_not() {
  echo -e "Hey $(whoami), hit me when you are ready"
  echo '(press any key to exit)'
  read -r -n 1
  exit 1
}

function n2st::good_morning_norlab() {
  # Global
  #   - Read GREETING global environment variable
  #
  echo "${GREETING:?'Error: Environment variable not set'} ... there's nothing like the smell of a snow storm in the morning!"
  return 0
}

function n2st::this_is_not_cool() {
    echo -e "\n[\033[1;31mERROR\033[0m] Noooooooooooooo!" 1>&2
    return 1
}
