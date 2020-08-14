# 📡 PDS Engineering Actions: Git Ping

This is an [action for GitHub](https://github.com/features/actions) that "pings" a repository branch by creating an empty commit and pushing to a specified branch. This is typically used to just trigger a GitHub action from another action's workflow.


## ℹ️ Using this Action

To use this action in your own workflow, just provide it `with` the following parameters:

- `repository`: The target repository name, with owner name separated by a slash, such as `nasa-pds/pdsen-corral`.
- `token`: A GitHub personal access token
- `branch`: The name of the branch to which to send the empty commit.
- `message`: The log message to use with the commit.


### 👮‍♂️ Personal Access Token

Note that in order to make the "ping" or "empty commit" to a repository, this action must havea access to repositories. This is afforded by the `token`. To set up such a token:

1. Vist your GitHub account's Settings.
2. Go to "Developer Settings".
3. Go to "Personal access tokens".
4. Press "Generate new token"; authenticate if needed.
5. Add a note for the token, such as "PDS Ping Repo Access"
6. Check the following scopes:
    - `repo:status`
    - `repo_deployment`
    - `public_repo`
7. Press "Generate new token"

Save the token (a hex string) and install it in your source, **not target**, repository:

1. Visit the source repository's web page on GitHub.
2. Go to "Settings".
3. Go to "Secrets".
4. Press "New secret".
5. Name the secret, such as `ADMIN_GITHUB_TOKEN`, and insert the token's saved hex string as the value.
6. Press "Add secret".

Use this name in the source's workflow, such as `${{secrets.ADMIN_GITHUB_TOKEN}}`. You should now destroy any saved copies of the token's hex string.


## 💁‍♀️ Demonstration

The following is a brief example how a workflow that shows how this action can be used:

```yaml
name: 👩‍🏫 Stable Genius Release
on:
  push:
    branches:
      - master
jobs:
  build:
    name: 👷‍♀️ Build Job
    runs-on: ubuntu-latest
    steps:
      - name: 💳 Check out the code
        uses: actions/checkout@v2
      - name: 🔧 Do something with it
        uses: …
      - name: 📡 Ping the PDS Engineering Corral
        uses: NASA-PDS/git-ping@master
        with:
          repository: nasa-pds/pdsen-corral
          token: ${{secrets.ADMIN_GITHUB_TOKEN}}
          branch: master
          message: Stable Genius service upgraded to ${{github.ref}}
```
