<div align="center">
<br>
<br>
<a href="https://norlab.ulaval.ca">
<img src="visual/norlab_logo_acronym_dark.png" width="200">
</a>
<br>

# _NorLab Project Template_

</div>


[//]: # (<b>Project related link: </b> &nbsp; )

[//]: # (Project related link:)
<div align="center">
<p>
<sup>
<a href="https://http://132.203.26.125:8111">NorLab TeamCity GUI</a>
(VPN or intranet access) &nbsp; • &nbsp;  
<a href="https://hub.docker.com/repositories/norlabulaval">norlabulaval</a>
(Docker Hub) &nbsp;
</sup>
</p>  

**This template repository is meant to help quick start repository creation for code related projects.** 
<br>
<br>
It has a few preconfigured tools such as a pull request template, a sematic-release github action, a standardized readme file with NorLab logo , a git ignore file with common file/directory entries, a
code owner designation file and
the basic directory structure. 

[![semantic-release: conventional commits](https://img.shields.io/badge/semantic--release-conventional_commits-453032?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

[//]: # (TODO: Un-comment the next line if your repository has run configuration enable on the norlab-teamcity-server)
[//]: # (<img src="https://img.shields.io/static/v1?label=powered by JetBrains TeamCity&message=CI/CD&color=green?style=plastic&logo=teamcity" />)

<br>

Maintainer: [Luc Coupal](https://redleader962.github.io)

</div>
<br>

**Note:** For `latex` project such as writing proposal or conference paper, use a template from the following list of [NorLab `TeX` template repositories](https://github.com/norlab-ulaval?q=template&type=all&language=tex&sort=) instead.  

## How to use this template repository

### Step 1 › Generate the new repository
1. Click on the button `Use this template` in green and on `Create a new repository`; 
    <br>
   ![img.png](visual/use_this_template_button.png)

### Step 2 › Make it your own

1. Customize the `README.md`:
   1. first finding a meaningful name, don't worry you can change it latter (see BC Gov [Naming Repos](https://github.com/bcgov/BC-Policy-Framework-For-GitHub/blob/master/BC-Gov-Org-HowTo/Naming-Repos.md) recommendation for advice and best-practice);
   2. change the maintainer name.
2. Modify the pull request template to fit your workflow needs: [pull_request_template.md](https://github.com/norlab-ulaval/template-norlab-project/tree/main/.github/pull_request_template.md);
3. Configure the repository directory structure for your project type
4. Validate the content of [`.gitignore`](https://github.com/norlab-ulaval/template-norlab-project/blob/1bd3db2f6c755bb273f7a23e49bae601123a7435/.gitignore) file.


[//]: # (&#40;ToDo&#41; Execute `repository_configuration_script.bash` and follow the instructions. You will be asked what kind of project your planning to undergo &#40;latex, ros, python, c++ ...&#41; and the component you wish to add to your repository.)

### Step 3 › Configure the _GitHub_ repository settings

[//]: # (&#40;ToDo&#41; Follow the `repository_configuration_checklist.md` steps.)

★ The `main` branch is sacred. It must be deployable at any time.  
 We strongly recommend you to configure your repository branching scheme following [**_Gitflow_**](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
 
 ```bash
 main ← dev ← feature 1
            ↖ feature 2
 ```
 with _**Branch Protection Rule**_ enable for the default branch (i.e. `main`) and the `dev` branches.

Go to the `Settings/Branches/Branch Protection Rule` panel and click `Add branch protection rule`

![branch_protection_rule_menu.png](visual/branch_protection_rule_menu.png)

and set the following:
1. Set _Branch name pattern_ to `main`
2. Set _Require a pull request before merging_
3. Set _Require conversation resolution before merging_
4. Set _Restrict who can push to matching branches_ and add names
5. If you use a Continuous Integration service such as _**GitHub actions**_ or our **_norlab-teamcity-server_**, set _Require status checks to pass before merging_ and set _Require branches to be up to date before merging_
6. Repeat for the `dev` branch
   


### Step 4 › Release automation: enable semantic versioning tools  

#### Why:
Assuming your repository is part of a bigger system, 
- easily identify the repository state currently in use as a dependency;
- and escape "dependency hell". 

#### How
Any push to the `main` branch will trigger the execution of [_semantic-release_](https://semantic-release.gitbook.io) which will analyse each commits message to determine the version bump following [_semantic versioning_](https://semver.org) scheme `MAJOR.MINOR.PATCH`.

**Note:** not each commits type trigger a version bump e.g.
`<type>!` triggers a `MAJOR` version bump, 
`fix` triggers a `PATCH` version bump, 
`feat` triggers a `MINOR` version bump 
and `doc, style ...` wont triggers anything.

On version bump, 
- the `CHANGELOG.md` and the `version.txt` files get updated;
- a new repository tag gets published with the newest versions number `v<MAJOR>.<MINOR>.<PATCH>`;
- a new repository release gets published on the _Releases_ page 


#### Configuration
1. Delete the content of `CHANGELOG.md` (see it as a quick-hack reset)
2. Adopt the [_conventional-commit_](https://www.conventionalcommits.org/) specification. This is a hard requirement for _semantic-release_. See [commit_msg_reference.md](https://github.com/norlab-ulaval/template-norlab-project/tree/main/commit_msg_reference.md) for a quick summary.
3. Use the _**semantic-release**_ GitHub action configured in the `.github/` directory. 
   1. You must generate a [Personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) 
   2. and register it as a _Repository Secrets_ in the tab `Settings/secrets and variables/Actions` and name it `SEMANTIC_RELEASE_GH_TOKEN`.  
     Reference: [semantic-release/GitHub Actions](https://semantic-release.gitbook.io/semantic-release/recipes/ci-configurations/github-actions)  
      

**Note:** to disable _semantic-release_, just delete `.github/workflows/semantic_release.yml`

---
