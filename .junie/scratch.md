
# Scratch

Your plan `.junie/plans/test_updates_plan.md` is good but your implementation is bad and does not follow `.junie/guidelines.md`.
Don't mock the logic that is actually tested.
Copying the source code instead of using the real one fall into the mocking category, don't do that.
Fix that please.
Always follow guidelines at `.junie/guidelines.md`.

---

Given the last two commits: 
- feat: enhance branch config, add JetBrains install logic and standalone mode Moments ago a0909d1a RedLeader962;
- feat: enhance setup scripts with additional checks and tools installation Today 17:38 684cd593 RedLeader962;
update unit-test and integration tests considering changes made to `configure_github_branch_protection.bash` and `initialize_norlab_project_template.bash`.
Create at least one test case per new feature option, update current tests cases otherwise.
Propose source code change if relevant. 
Update Markdown documentation accordingly. 
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Always follow guidelines at `.junie/guidelines.md`.


---

Improve `configure_github_branch_protection.bash`: 
- remove `gbp::status_check_configuration` function usage everywhere;
- delete `gbp::status_check_configuration` function;
- update tests accordingly.
Follow guidelines at `.junie/guidelines.md`.
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Propose source code change if relevant.
Execute all unit-tests and all integration tests before submitting.

---

Don't assume the default branch is `main`.
The default branch is arbitrary and is set on GitHub.
Review your proposed solution accordingly.
Follow guidelines at `.junie/guidelines.md`.

---

Improve `configure_github_branch_protection.bash`: add logic to _rename_ the git branch _release branch_ if using a non-default name instead of creating a new one.
Follow guidelines at `.junie/guidelines.md`.
Update `tests/tests_bats/test_configure_github_branch_protection.bats` and `tests/tests_dryrun_and_tests_scripts/dryrun_configure_github_branch_protection.bash` accordingly.
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Propose source code change if relevant.
Update Markdown documentation accordingly. 
Execute all unit-tests and all integration tests before submitting.

--

You are not done. Unit-test are failing.
Use `\r` instead of `\n` to simulate the return key.
Always follow guidelines at `.junie/guidelines.md`.

---

Add an interactive step in `initialize_norlab_project_template.bash` at the execution of `bash configure_github_branch_protection.bash` so that user can decide to set non-default _release branch_ and _bleeding edge branch_ name. In effect the value fetch from user input would be passed to the option flag `--release-branch BRANCH_NAME` and `--dev-branch BRANCH_NAME` implemented in `configure_github_branch_protection.bash`.
Update tests accordingly.
Create at least one test case for this new feature, update current tests cases otherwise.
Always follow guidelines at `.junie/guidelines.md`.


---

You miss understood my instructions, 
- I said ADD logic to update `semantic_release.yml` field `branches` name `main` to user set _release branch_ name if using non-default. 
- You have remove the already implemented logic for updating `.releaserc.json`
- Both update logic are required:  `semantic_release.yml` and `.releaserc.json`.
Integration tests `TODO` and `TODO` are all failing. 
Please investigate and make the required changes. 
Always follow guidelines at `.junie/guidelines.md`.

---

Add logic to update `semantic_release.yml` field `branches` name `main` to user set _release branch_ name if using non-default.
Remove logic to set non-default _pre-release branch_ i.e., `beta` branch.
Always follow guidelines at `.junie/guidelines.md`.

---

Add logic for managing _pre-release branch_ with default name `beta`.
Add `beta` to the default cli case.
Add option to change the _pre-release branch_ default name.
Add logic to update `.releaserc.json` 
- field `branches` name `main` to user set _release branch_ name if using non-default; 
- field `branches` name `beta` to user set _pre-release branch_ name if using non-default.
Always follow guidelines at `.junie/guidelines.md`.

---

Rename `gbp::interactive_configuration` function to a more accurate name e.g., `gbp::status_check_configuration`.
For integration testing:
- add a _setup_ step in `test_configure_github_branch_protection.bash` which clone https://github.com/norlab-ulaval/dockerized-norlab-project-mock-EMPTY.git as a submodule to the `utilities` directory;
- update the `SRC_CODE_PATH` to use `utilities/tmp/dockerized-norlab-project-mock-EMPTY`;
- add a teardown step in `test_configure_github_branch_protection.bash` which reset the  https://github.com/norlab-ulaval/dockerized-norlab-project-mock-EMPTY.git GitHub settings to their original state and than delete `utilities/tmp/dockerized-norlab-project-mock-EMPTY`.


---

Ok, lets concentrate on solution 1, you can delete solution 2 and 3 from the plan.
Update the plan solution 1 according to the changes I made to the `README.md` at section _Step 3 › Make it your own_.
Add logic to create the target branch if it does not exist.
Delete logic related to "Add specific users who can push to protected branches".
Add logic to set the branches name to an arbitrary name in the default cli case where both the _release branch_ and the _bleeding edge branch_ are configured, default should be _release branch_=`main` and _bleeding edge branch_`dev`. 
Propose a corresponding testing strategy and script implementation.


---

Propose me a plan to implement a script that would configure the github branch protection rule mentioned in the `README.md` at section _Step 3 › Make it your own_.
Show me examples of how you would do it.
Submit me the plan for review when ready.
Put the plan in the `.junie/plans` directory.
Follow guidelines at `.junie/guidelines.md`.

Propose a corresponding testing strategy for each proposed solutions.
Consider alternative solution so that we can have option to decide the best course of action;

--

Update bats test at `tests/tests_bats/test_version.bats` considering change made to `src/lib/commands/version.bash`.
Follow guidelines at `.junie/guidelines.md`.
Create at least one test case per new command argument and/or options, update current tests cases otherwise.
Propose source code change if relevant. 
Update Markdown documention accordingly. 
Check if it introduce any breaking change in the code base by runnning both unit-tests and integration tests.

---

Read and implement the updated plan at `.junie/plans/documentation_updates_proposal.md`.
Follow guidelines at `.junie/guidelines.md`.

