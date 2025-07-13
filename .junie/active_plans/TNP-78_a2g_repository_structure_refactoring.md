# _AI Agent Guidelines (A2G)_ repository structure refactoring plan

## Goal
Improve A2G repository file structure organization so that it is easier to use and maintain.

YouTrack task: TNP-78 refactor: Improve A2G repository structure 

## Repository structure

### Current file structure tree

```text
.junie/ai_agent_guidelines
├── specialized_guidelines/
│   ├── guidelines.markdown.md
│   ├── guidelines.n2st.md
│   ├── guidelines.nbs.md
│   ├── guidelines.python.md
│   └── guidelines.shell_script.md
├── specialized_recipes/
│   ├── recipes.ai_agent.md
│   ├── recipes.general.md
│   ├── recipes.n2st.md
│   ├── recipes.nbs.md
│   ├── recipes.python.md
│   └── recipes.shell_script.md
├── template/
│   ├── .junie/
│   │   ├── ai_ignored
│   │   │   ├── recipes.md
│   │   │   └── scratch.md
│   │   ├── guidelines.a2g_config.md
│   │   └── guidelines.md
│   ├── specialized_guidelines/
│   ├── .gitignore
│   └── .aiignore
├── tools/
│   └── ...
├── visual/
│   └── ...
├── CHANGELOG.md
├── README.md
├── glossary.md
├── guidelines.a2g_framework.md
├── guidelines.a2g_general.md
├── quick_reference.md
├── validation_checklist.md
└── version.txt
```


### Expected file structure tree
```text
.junie/ai_agent_guidelines
├── guidelines/
│   ├── specialized_guidelines/
│   │   ├── guidelines.markdown.md
│   │   ├── guidelines.n2st.md
│   │   ├── guidelines.nbs.md
│   │   ├── guidelines.python.md
│   │   └── guidelines.shell_script.md
│   └── guidelines.a2g_general.md
├── recipes/
│   ├── specialized_recipes/
│   │   ├── recipes.ai_agent.md
│   │   ├── recipes.n2st.md
│   │   ├── recipes.nbs.md
│   │   ├── recipes.python.md
│   │   └── recipes.shell_script.md
│   └── recipes.general.md
├── framework/
│   ├── guidelines.a2g_framework.md 
│   ├── guidelines.a2g_glossary.md                     <- renamed from 'glossary.md' 
│   ├── guidelines.a2g_quick_reference.md              <- renamed from 'quick_reference.md' 
│   └── guidelines.a2g_validation_checklist.md         <- renamed from 'validation_checklist.md' 
├── template/
│   ├── .junie/
│   │   ├── ai_ignored
│   │   │   ├── recipes.md
│   │   │   └── scratch.md
│   │   ├── a2g_config.yaml                            <- renamed from 'ai_agent_config.yml'
│   │   ├── guidelines.a2g_config.md
│   │   └── guidelines.md
│   ├── specialized_guidelines/
│   ├── .gitignore
│   └── .aiignore
├── tools/
│   └── ...
├── visual/
│   └── ...
├── a2G_entrypoint.md
├── CHANGELOG.md
├── README.md
└── version.txt
```

## Instructions

### Planning phase
1. Inspect and validate the expected file structure tree. 
2. Provide your assessment in the console and wait for my approval before proceeding with the refactoring phase.

### Refactoring phase
1. Refactor directory structure according to the expected file structure tree
2. Rename files according to the expected file structure tree
3. Update A2G `.junie/ai_agent_guidelines` files references accordingly
4. Update super project `.junie` files references accordingly
5. List files that are ai ignore but should be updated in summary

### Refactoring Strategy
Definition: **Expected Outcome** as stated at the end of `.junie/active_plans/task2_a2g_improvement_plan.md` plan:  "A2G framework ready for optimal AI agent deployment with 95%+ efficiency rating".
Establish feedback loop for measuring AI agent guideline efficiency improvement: 
    1. execute refactoring phase;
    2. read files and measure efficiency;
    3. repeat step 1 until **expected outcome** reached (as stated above). 
