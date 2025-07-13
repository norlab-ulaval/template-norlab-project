# A2G Guidelines Configuration (A2G-super-config)

## Configuration Note

Variable declarations and specialized guidelines activation rules are now managed through:
- **Variable Configuration**: `.junie/ai_agent_config.yml` - Contains all A2G configuration variables with dynamic resolution
- **Activation Logic**: `.junie/ai_agent_guidelines/guidelines.a2g_framework.md` - Contains specialized guidelines activation triggers and precedence rules

## A2G Instructions

- In addition to the A2G-super repository guidelines at `.junie/guidelines.md`:  
  - start with the A2G entrypoint at `.junie/ai_agent_guidelines/entrypoint` which redirects to the framework guidelines;
  - review A2G _framework_ guidelines specified in `.junie/ai_agent_guidelines/guidelines.a2g_framework.md`;
  - review the following A2G specialized guidelines from directory `.junie/ai_agent_guidelines/specialized_guidelines`:
    - `guidelines.markdown.md` -> markdown
    - `guidelines.n2st.md` -> n2st library
    - `guidelines.nbs.md` -> nbs library
    - `guidelines.python.md` -> python
    - `guidelines.shell_script.md` -> shell script
