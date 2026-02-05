# How to use

- Create **.github/workflows** folder in your repo
- create a workflow file. ('test.yml`)
- use this action-club workflow inside `steps[].uses` key as below

```yml
name: markdown-lint
run-name: Linting markdown files

on:
  push:
    <<: &filters
    branches: [main, develop]
    paths: ["**.md", "**.mdx"]
  pull_request:
    <<: *filters #reference syntax

jobs:
  markdown-lint:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Lint Markdown files
        uses: recursivezero/action-club/member/test-token@main
```

hope it helps.
