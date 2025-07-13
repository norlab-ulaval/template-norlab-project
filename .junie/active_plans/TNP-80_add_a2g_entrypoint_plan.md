# _AI Agent Guidelines (A2G)_ repository structure refactoring plan

## Goal
Improve A2G repository file structure organization so that it is easier to use and maintain.

YouTrack task: TNP-80 feat: add A2G entry point file 

## Repository structure

### Current file structure tree

```text
.junie/ai_agent_guidelines
├── specialized_guidelines/
├── specialized_recipes/
├── template/
├── tools/
├── visual/
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
├── specialized_guidelines/
├── specialized_recipes/
├── template/
├── tools/
├── visual/
├── CHANGELOG.md
├── README.md
├── glossary.md
├── guidelines.a2g_framework.md
├── guidelines.a2g_general.md
├── quick_reference.md
├── validation_checklist.md
├── a2G_entrypoint.md
└── version.txt
``` 

## Instructions

### Implementation
1. Add repository entrypoint:
   - It's role just to be a stable point of entry to the repository and redirect to the file with the main logic, i.e., `guidelines.a2g_framework.md` 
   - Call it `a2G_entrypoint` with no postfix
   - Make it point to `guidelines.a2g_framework.md`
2. Update `guidelines.a2g_config.md` and `guidelines.md` accordingly
3. Update A2G remaining code base accordingly

### Implementation Strategy
Definition: **Expected Outcome** as stated at the end of `.junie/active_plans/task2_a2g_improvement_plan.md` plan:  "A2G framework ready for optimal AI agent deployment with 95%+ efficiency rating".
Establish feedback loop for measuring AI agent guideline efficiency improvement: 
    1. execute refactoring phase;
    2. read files and measure efficiency;
    3. repeat step 1 until **expected outcome** reached (as stated above). 
