# Plan: Add the files the template still lacks

## Goal

`template/` provides a README skeleton, a license, a Python project's files, and the Claude Code project settings, each offered to the projects that want it.

## The files

- **`README.md`**, a skeleton for the project to fill in. `cp -rn` already leaves a project's own README alone.
- **`LICENSE`**, a choice of license or none. The choice is a question, so without copier each project picks its own.
- **A Python project's files**: `pyproject.toml` from `uv init`, `src/` and `tests/` directories, and `.venv/` and `__pycache__/` in `.gitignore`. Only a Python project wants them, which is also a question.
- **`.claude/settings.json`**, the project-level route to the Claude Code gates, from dotfiles' [plan to make the gates easy to adopt](https://github.com/francisco-camargo/dotfiles/blob/main/plans/hook-scripts.md). Whether to include it is a question too.

## Steps

- [ ] Add a `README.md` skeleton.
- [ ] Add the license choice.
- [ ] Add a Python project's files.
- [ ] Add `.claude/settings.json`, once dotfiles' hook-scripts plan has a snippet to copy.

## Docs to update

- [ ] `README.md`: list the new files under what the template provides.

## Updates to send

None.

## Open questions

- How does a project choose a license, or whether it is a Python project, without copier? I lean towards waiting on the [copier plan](copier.md) for these, and adding the README skeleton first, since every project wants one.

## Done when

A new project can take each file above, and one that does not want a file does not get it.
