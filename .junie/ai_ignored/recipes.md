# Prompt Instruction Recipes
Is AI ignore

## General

```markdown
Read and implement the plan at `.junie/plans/readme_improvement_plan.md`.
```

```markdown
Review guidelines at `.junie/guidelines.md`.
Execute all unit-tests and all integration tests before submitting.
```

```markdown
Add/refactor/improve TODO 
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Propose source code change if relevant. 
Update Markdown documentation accordingly. 
```

```markdown
Inspire yourself with `TODO`.
```

## Bats unit-test generation 

```markdown
Implement a bats test for `TODO`.
Review guidelines at `.junie/guidelines.md`.
Inspire yourself with `tests/test_TODO`.
Create at least one test case per command argument and/or options.
Test relevant option and arguments combination.
You can mock their corresponding functions as the intended purposes of this test file is for unit-testing the CLI functionalities.
Propose source code change if relevant. 
Update Markdown documentation accordingly. 
Execute all unit-tests and all integration tests before submiting.
```

## Improve/refactor source code

```markdown
Refactor/improve `src/TODO`.
TODO
Review guidelines at `.junie/guidelines.md`.
Update `test_TODO` accordingly.
Create at least one test case per new command argument and/or options, update current tests cases otherwise.
Test relevant option and arguments combination.
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Propose source code change if relevant.
Update Markdown documentation accordingly. 
Execute all unit-tests and all integration tests before submitting.
```

## Modify proposed tests solutions 

```markdown
In `test_TODO.bats`, instead of mocking `find`, `grep`, `cut`, `cd`, `pwd`, `command` and `basename` command, use the real one and tests the result using bats assert functionalities as instructed in `guidelines.md`
```

```markdown
Integration tests `TODO` and `TODO` are all failing. 
Please investigate and make the required changes. 
Review guidelines at `.junie/guidelines.md`.
```

```markdown
You overcomplicated `TODO` new test cases. 
Don't test flag that are not part of the cli definition even if they are mentioned in the doc.
You only need a test case for TODO
```

````markdown
The following proposed code in `TODO` is overcomplicated 

```shell
TODO
```

Instead, inspire yourself with `TODO` implementation:

```shell
TODO
```

Its clearer, explicit and more intuitive.
````
 
