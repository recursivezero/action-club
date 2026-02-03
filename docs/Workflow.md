# Workflow

mainly 40 events supported by GitHub Actions which are mainly as follow

here’s a more complete list of the **major workflow events** GitHub supports:

## Commonly Used Events

- **push** – commits pushed to a branch
- **pull_request** – PR opened, synchronized, reopened, closed
- **create** – branch or tag created
- **delete** – branch or tag deleted
- **fork** – repository forked
- **workflow_dispatch** – manual trigger
- **workflow_call** – triggered by another workflow
- **schedule** – cron-like scheduled runs
- **repository_dispatch** – external/custom trigger
- **release** – release published, edited, or deleted

### Collaboration & Review

- **issues** – issue opened, edited, closed
- **issue_comment** – comment added to an issue
- **discussion** – discussion created, answered, deleted
- **discussion_comment** – comment added to a discussion
- **pull_request_review** – review submitted
- **pull_request_review_comment** – comment added to a PR review

### Repository & Admin

- **branch_protection_rule** – branch protection rule changes
- **repository** – repo created, archived, transferred, deleted
- **gollum** – wiki page created or updated
- **page_build** – GitHub Pages build completed

### Security & Dependency

- **dependabot** – Dependabot alerts/updates
- **secret_scanning_alert** – secret scanning alert detected
- **code_scanning_alert** – code scanning alert created/resolved

---

### Key Difference

- Some events are **code-centric** (push, create, delete).
- Others are **collaboration-centric** (issues, PRs, discussions).
- A few are **admin/security-centric** (repository, branch_protection_rule, dependabot).

## Typical workflow

```yaml
name: Comprehensive Workflow

on:
  push:
    branches:
      - main
  create:        # branch or tag creation
  gollum:        # wiki page created or updated
  page_build:    # GitHub Pages build completed
  release:
    types: [published]

jobs:
  build:
    runs-on: ubuntu-latest
    if: github.event_name == 'push'
    steps:
      - uses: actions/checkout@v4
      - run: echo "Build triggered by push to main"

  branch-create:
    runs-on: ubuntu-latest
    if: github.event_name == 'create' && github.event.ref_type == 'branch'
    steps:
      - run: echo "Branch created: ${{ github.ref }}"

  tag-create:
    runs-on: ubuntu-latest
    if: github.event_name == 'create' && github.event.ref_type == 'tag'
    steps:
      - run: echo "Tag created: ${{ github.ref }}"

  wiki-update:
    runs-on: ubuntu-latest
    if: github.event_name == 'gollum'
    steps:
      - run: echo "Wiki page updated"

  pages:
    runs-on: ubuntu-latest
    if: github.event_name == 'page_build'
    steps:
      - run: echo "GitHub Pages build completed"

  release-notify:
    runs-on: ubuntu-latest
    if: github.event_name == 'release'
    steps:
      - run: echo "Release published: ${{ github.event.release.tag_name }}"
```

## Activity Types

When one declare an event like issues or `pull_request`, one can optionally filter by activity types (sometimes called “sub‑events”)

```yaml
on:
  issues:
    types: [opened, edited, labeled, closed]
```

if we do not write types then it will trigger on all supported `issue` activities by default which are as below

- opened,
- edited,
- deleted,
- transferred,
- pinned,
- unpinned,
- labeled,
- unlabeled,
- locked,
- unlocked,
- closed,
- reopened,
- assigned,
- unassigned,
- milestoned,
- demilestoned.

Similarly, Default activities for `pull_request` events are

- opened,
- edited,
- closed,
- reopened,
- assigned,
- unassigned,
- labeled,
- unlabeled,
- review_requested,
- review_request_removed,
- ready_for_review,
- locked,
- unlocked,
- synchronize,
- converted_to_draft,
- auto_merge_enabled,
- auto_merge_disabled

some other events have these sub-events

`release` → published, unpublished, created, edited, deleted, prereleased

`workflow_run` → requested, completed

`discussion` → created, edited, deleted, answered, unanswered

`discussion_comment` → created, edited, deleted

## Key Rules

- No types specified → all sub‑events trigger.

- types specified → only those listed sub‑events trigger.

- This applies consistently across events that support activity filtering.

- Some events (like `push`, `create`, `delete`) don’t use types; they rely on filters like `branches`, `tags`, or `ref_type`
