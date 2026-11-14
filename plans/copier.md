# Plan: Consider copier

## Goal

Decide whether to generate and update projects from this repo with [Copier](https://copier.readthedocs.io/), and adopt it if so.

## Why

Copying `template/` by hand has two limits.
It cannot ask a question, so a Python project and a shell project get the same files.
And a project has no link back, so a fix made here never reaches a project that copied an earlier version.

Copier removes both.
It generates a project from a template, asks questions on the way, and can later update the project as the template changes.
Nothing has to be cloned by hand:

```sh
uvx copier copy --trust gh:francisco-camargo/repo-template my-project
```

Months later, inside that project:

```sh
uvx copier update
```

`uvx` runs a tool from PyPI without installing it, so the user needs `uv` and `git` and nothing else.

## How a template is built

- **`copier.yml`** at the root holds the questions and the settings.
- **`_subdirectory: template`** points copier at the directory this repo already uses, so adopting copier moves no files.
- **Files ending in `.jinja`** are rendered, so `README.md.jinja` can use the project name from an answer. Files without the suffix are copied as they are.
- **Jinja in a file name** makes a file conditional on an answer, such as a `pyproject.toml` that only appears in a Python project.
- **`_skip_if_exists`** names files a project owns once they exist, such as `README.md`.
- **`_tasks`** lists commands to run after copying, such as `git init` and `pre-commit install`. Copier refuses to run them unless the user passes `--trust`, which asks the user to trust the template with a shell.
- **`_message_after_copy`** is text printed at the end, which is where the GitHub settings in [Use it](../README.md#use-it) would go.

## How updating works

A project records its answers, and the template version it came from, in `.copier-answers.yml`, which gets committed.
`copier update` needs, in copier's words, a project that "includes a valid .copier-answers.yml file", a template "versioned with Git (with tags)", and a project "versioned with Git", with a clean `git status`.
It then does a three-way merge between the old template version, the new one, and the project as it stands.
A conflict shows up as inline markers, the same as in a `git merge`.

## What it costs

- **Python**, 3.10 or newer, though `uvx` fetches it for a person running one command.
- **Jinja is harder to read** than a plain file. Keeping `.jinja` to the files that need an answer limits that.
- **Releases need tags.** A fix is not available to `copier update` until it is tagged.
- **GitHub's "Use this template" button stops being useful**, because it would copy `copier.yml` and raw `.jinja` files.

## When it earns its cost

The decision turns on how many projects use this repo and how often the files change.
With a few projects and rare changes, `cp -rn` and a `diff` are enough.
Once fixes keep failing to reach projects, copier earns its cost.

## Steps

- [ ] Add `copier.yml` with `_subdirectory: template` and no questions, and tag a version.
- [ ] Trial `copier copy` into a clone of dotfiles, a project copier did not create: check that it asks before overwriting each file that differs, then writes `.copier-answers.yml`. Merge dotfiles' own lines back by hand, using dotfiles' [repo-template-check skill](https://github.com/francisco-camargo/dotfiles/tree/main/claude/skills/repo-template-check) to find them.
- [ ] Make a change here, tag it, and check that `copier update` in the trial clone applies it.
- [ ] Decide on adoption from the trial; if no, delete `copier.yml` and this plan.
- [ ] Add the post-copy setup, as `_tasks` or `_message_after_copy` per the open question below.

## Docs to update

- [ ] `README.md`: replace the `cp -rn` instructions in [Use it](../README.md#use-it) with `uvx copier copy`, and say how to update.

## Updates to send

- [ ] dotfiles' repo-template-check skill: say whether it should check `.copier-answers.yml`, once adoption is decided.

## Open questions

- Should copying run `git init` and `pre-commit install`? `_tasks` could, but only with `--trust`. I lean towards printing the commands in `_message_after_copy`, which avoids the trust prompt and costs the user two lines of typing.

## Done when

A project created with `copier copy` takes a later tagged change with `copier update`, or the trial showed copier is not worth it and the decision is recorded in the README.
