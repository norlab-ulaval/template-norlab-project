# Improve _AI Agent Guidelines (A2G)_ Configuration Logic

YouTrack task: TNP-79 feat: improve A2G config logic

## Goal

Variable configuration file `.junie/ai_agent_config.yml` should:
- Only contain relevant A2G configuration variables;
- Only contain variables that are used by A2G files;
- Should become the main access point for setting variables;
- Some variables should have dynamic resolution when relevant and when possible. 

## Tasks

### Planning Phase
- [ ] Would it be clearer if we had two separate configuration files, one for variables set manually by User and one for dynamically set variables? 
- [ ] Is it still relevant to keep `.junie/guidelines.a2g_config.md` file as a Markdown file if we go with a two separate yaml configuration files. `guidelines.a2g_config.md` specialized guidelines selection logic could be merged in the yaml manual configuration file which would simplify usage and the "review A2G _framework_ guidelines specified in `.junie/ai_agent_guidelines/guidelines.a2g_framework.md`" instruction could replace the "review _A2G Guidelines Configuration_ specified in `.junie/guidelines.a2g_config.md`" instruction in `.junie/guidelines.md`.
- [ ] Submit your analysis and wait for approval before executing the implementation phase 

### Implementation Phase
- [ ] assess what variables in `.junie/ai_agent_config.yml` are really useful to AI agent when using A2G
- [ ] clean up the noise in `.junie/ai_agent_config.yml` i.e., remove unused variables, remove duplicated logic 
- [ ] Update A2G `.junie/ai_agent_guidelines` files references accordingly
- [ ] Update super project `.junie` files references accordingly

### Refactoring Strategy
Definition: **Expected Outcome** as stated at the end of `.junie/active_plans/task2_a2g_improvement_plan.md` plan:  "A2G framework ready for optimal AI agent deployment with 95%+ efficiency rating".
Establish feedback loop for measuring AI agent guideline efficiency improvement: 
    1. execute implementation phase;
    2. read files and measure efficiency;
    3. repeat step 1 until **expected outcome** reached (as stated above). 
 
