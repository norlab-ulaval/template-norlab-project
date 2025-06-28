
# Repository Guidelines
 
## General Requirements:
- Don't repeat yourself: 
  - Use already implemented code whenever possible.
  - Leverage functionality provided by submodule such as _N2ST_ and _NBS_ library whenever possible.
  
## Repository Organization
- `src/` contain repository source code
- `tests/` contain tests files
- `tests/tests_bats/` contain N2ST bats framework files that are mainly used for unit-testing
- `utilities/` contain external libraries such as N2ST and NBS

## Version Control
- Never `git add` or `git commit` changes, all changes require explicit code review and acceptance by the code owner.   

## Tests Requirements
- In the context of testing:
  - the definition of _pass_ is that a test exit without error. Synomym: _green_, _successful_; 
  - the definition fo _done_ mean that all tests where executed and all tests passed.

## General Testing Instructions
- Inspect the tested script/functions for business logic related error or implementation error. Propose correction before going forward if any. 
- Write tests who challenge the intended functionality or behavior.
- Identify relevant test cases e.g., behavior validation, error handling, desired user feedback, ...   
- Divide test file by test cases: one test function per test case.
- If the tested script implement helper functions (i.e., support function meant to be used by the main function), test those functions first.
- Provide a summary explanation of the test case: 
  - What does it test for; 
  - What's the test expected outcome (i.e, should it pass or fail); 
  - If you do mock something, justify why.
- All tests in the `tests/` directory must pass.
- Always execute all unit-tests and all integration tests before submitting.
- Their should be at least one test file per corresponding source code file.
- Write **Unit-tests** and/or **Integration tests**:
  - All new scripts or functionalities need to have (either or both):
    - **Unit-tests**: 
      - Those are tests that check if the core expected behaviors are satisfy. It test a piece of code in a stand alone fashion.  
    - **Integration tests**: 
      - Those are test case where there is multiple script interacting whith each other or we want to assess execution from beginning to end;

### General Mocking Instructions
- Never mock the functions that are tested in the tested script.

### General Instructions On Tests Execution
- Always run unit-tests before integration tests.
- Never run integration tests if any unit-tests fail.

## Shell Script specific Testing Instructions
All instructions in sections _General Testing Strategy_ plus the following:
- All new scripts or functionalities need to have (either or both):
  - **Unit-tests**: 
    - Use [N2ST](https://github.com/norlab-ulaval/norlab-shell-script-tools) bats tests tools for unit-test (See `tests/run_bats_core_test_in_n2st.bash` script) and a corresponding bats unit-test `.bats` file in the `tests/tests_bats/` directory. N2ST Bats tests are running in a docker container in complete isolation with a copy of the source code.
  - **Integration tests**: 
    - Those tests are divided in two categories: 
      - Dryrun: either make use of a `--dry-run` flag implemented in the script or make use of the docker `--dry-run` flag;  
      - Test: all other integration test case that are not dryrun.
    - Use [NBS](https://github.com/norlab-ulaval/norlab-build-system) tests tools for integration-test (See `tests/run_all_dryrun_and_tests_script.bash` script) and a corresponding `test_*` or `dryrun_*` script in the `tests/tests_dryrun_and_tests_scripts/` directory.
    - New integration test script must go in the `tests/tests_dryrun_and_tests_scripts/` directory.
- Their should be at least one test file (`.bats` and/or `.bash`) per corresponding source code file.


### Shell Script specific Mocking Instructions
All instructions in sections _General Mocking Instruction_ plus the following:
- Never mock the functions that are tested in the tested script.
- You can mock shell core command an docker command.
- You can mock `docker [OPTIONS|COMMAND]` commands and `git [OPTIONS|COMMAND]` commands.
- Avoid mocking N2ST functions, at the exception of those in `${N2ST_PATH}/src/function_library/prompt_utilities.bash`. For example, instead of re-implementing `n2st::seek_and_modify_string_in_file`, just load the real one and test that the content of the file at `file_path` has been updated? You can find the real one in `${N2ST_PATH}/src/function_library/general_utilities.bash`.
- Avoid mocking the `read` command. Instead use `echo 'y'` or `echo 'N'` for piping a keyboard input to the function who use the `read` command which in turn expect a single character, example: `run bash -c "echo 'y' | <the-tested-function>"`. Alternatively, use the `yes [n]` shell command which optionaly send [y|Y|yes] n time, example: `run bash -c "yes 2 | <the-tested-function>"`.

### Instructions On Bats Tests
- Use bats framework `bats-file` helper library provide tools for temporary directory management, such as the `temp_make` and `temp_del` functions. 
  Reference https://github.com/bats-core/bats-file?tab=readme-ov-file#working-with-temporary-directories
- Use bats test function `assert_file_executable` and `assert_file_not_executable` to test executable.
- Use bats test function `assert_symlink_to` and `assert_not_symlink_to` to test symlink.
- You can test directory/file mode, existence, permision, content and symlink directly without mocking since bats tests are running in a docker container in complete isolation.
- Test `/usr/local/bin/dna` symlink related logic directly without mocking.

Bats helper library documentation:
  - https://github.com/bats-core/bats-assert
  - https://github.com/bats-core/bats-file
  - https://github.com/bats-core/bats-support

### Shell Script specific Instructions On Tests Execution
All instructions in sections _General Instruction On Tests Execution_ plus the following:
- Don't directly execute `.bats` files, instead execute from the repository root `bash ./tests/run_bats_core_test_in_n2st.bash tests/tests_bats/<bats-file-name>.bats`.
- Don't set tests script in executable mode, instead execute them with `bash <the-script-name>.bash`. 


## Python Specific Testing Instructions
When creating new tests:
1. Place tests in the appropriate subdirectory based on what you're testing
2. Follow the existing naming conventions (`tests_*` for package, `test_*.py` for files, `test_*` for functions)
3. Use pytest fixtures from conftest.py for common setup/teardown if exist in directory or parent directory
4. Use parametrization for testing multiple scenarios
5. Regroup test function that tests different case of same function or class under a test class following the pytest test discovery naming convention like in the following example:

### Python Specific Instructions On Tests Execution
To run tests, use the pytest command from the project root or tests directory:

```bash
# Run all tests
python -m pytest

# Run tests with verbose output
python -m pytest -v

# Run tests in a specific directory
python -m pytest tests/tests_tools

# Run a specific test file
python -m pytest tests/tests_tools/tests_console_tools/test_terminal_splash.py

# Run a specific test function
python -m pytest tests/tests_tools/tests_console_tools/test_terminal_splash.py::test_norlab_splash
```
