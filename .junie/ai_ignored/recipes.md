# Prompt Instruction Recipes

Is AI ignore

## General

```markdown
Read and implement the plan at `.junie/active_plans/TODO.md`.
```

```markdown
Review guidelines at `.junie/guidelines.md`.
Execute all unit-tests and all integration tests before submitting.
```

```markdown
Add/refactor/improve `FILE_NAME`
Check if it introduce any breaking change in the code base by running both unit-tests and integration tests.
Propose source code change if relevant.
Update Markdown documentation accordingly. 
```

```markdown
Inspire yourself with ....
```


## Improve/refactor source code

```markdown
Refactor/improve `FILE_NAME`.
TODO
Review guidelines at `.junie/guidelines.md`.
Update `test_FILE_NAME` accordingly.
Create at least one test case per new command argument and/or options, update current tests cases
otherwise.
Test relevant option and arguments combination.
Check if it introduce any breaking change in the code base by running both unit-tests and
integration tests.
Propose source code change if relevant.
Update Markdown documentation accordingly.
Execute all unit-tests and all integration tests before submitting.
```

## Modify proposed tests solutions

```markdown
Integration tests `test_FILE_NAME1` and `test_FILE_NAME2` are all failing.
Please investigate and make the required changes.
Review guidelines at `.junie/guidelines.md`.
```

```markdown
You overcomplicated `FILE_NAME` new test cases.
Don't test flag that are not part of the source code definition even if they are mentioned in the doc.
You only need a test case for TODO
```

````markdown
The following proposed code in `FILE_NAME1` is overcomplicated

```shell
TODO
```

Instead, inspire yourself with `FILE_NAME2` implementation:

```shell
TODO
```

Its clearer, explicit and more intuitive.
````
 
