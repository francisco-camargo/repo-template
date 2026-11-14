# Plan: Run the gates in CI

## Goal

A workflow runs `pre-commit run --all-files` on every push and pull request, so a commit made in a clone without the hooks still meets the gates before a merge.

## Why

The gates run only in a clone where someone ran `pre-commit install`, so a commit made anywhere else skips them.
A workflow catches those commits after the fact, but before a merge.

## The link check

The template runs lychee, which fails a commit when a Markdown link points at a file or heading that is not there.
dotfiles first added a check like it as specific to that repo.

- **For keeping it in every project:** every project that starts here has a README, and most will link within it.
- **Against:** the first run downloads lychee through an installer that Windows may flag.

The workflow is the first place lychee's download runs on Linux, so this plan settles both.

## Steps

- [ ] Add a workflow under `template/.github/workflows/` that runs `pre-commit run --all-files` on push and pull request.
- [ ] Add the same workflow to this repo, with `--config template/.pre-commit-config.yaml` since the root has no config of its own, and check that it passes on GitHub, lychee included.
- [ ] Settle the lychee question below, and drop the hook from `template/.pre-commit-config.yaml` if the answer is no.

## Docs to update

- [ ] `README.md`: say that the gates also run in CI, and what that catches.

## Updates to send

None.

## Open questions

- Does lychee belong in every project? I lean towards yes, since broken links within a README are the commonest Markdown fault, unless the Windows installer keeps getting flagged.

## Done when

A push to this repo runs the workflow, and it passes.
