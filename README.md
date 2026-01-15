# Action Club

![Action][action]
![License][license]
![Open Issues][issues]
![Commit Count][commits]
![Total Pull Request][PR]

Collection of github actions and workflow

## How to use this repository

- check the repo tags and use that in your workflow

## Workflows included

### auto-assign-project

- When a issue opened then we add assignee and label and if there are Project in the repo then this workflow tag the project and mark issue in TODO stat
- When A PR raised then add status to _In Progress_

Note: A Project should be there in your github and that be linked with the repo

### format-issue-title

- When an issue is created then , it will change the issue title based on a prefix provided and the format will be like `TZX-<Year>000<issue-number>`

### issue-branch-sync

- When a branch is generated based on issue title then this workflow
  - Add comments under the issue that a branch has been generated
  - and assign a label `development` to the issue.( generate label if it is not there)

### lint-n-build

- When we push code or raise PR then this workflow run for lint and build script to check whether there are any issue in the commit

### markdown-lint

- When we push code and there are markdown file then we run markdownlint and check for issue

Note: we must have `.markdownlint.json` file in project root

### release-build

This will run build command when we push code or merge PR into `release` branch then it run and create dist folder; which help to run code on cloud

### test-token

A basic workflow to check the repo secrets expires or invalid

for that ; create a Classic Token for account and then create a secrets in the repo and paste this token value.

### version-bump

This workflow runs when we push code into `main` branch then it update the package.json version and also update changelog.md file

###

## Changelog

See what’s new in each version: [CHANGELOG.md](./CHANGELOG.md)

> :copyright: _RecursiveZero_ Private Limited

> <!-- References -->

[action]: https://badgen.net/badge/icon/github?icon=github&label=action
[license]: https://badgen.net/github/license/recursivezero/action-club
[issues]: https://badgen.net/github/open-issues/recursivezero/action-club
[PR]: https://badgen.net/github/prs/recursivezero/action-club
[commits]: https://badgen.net/github/commits/recursivezero/action-club/main?color=green
