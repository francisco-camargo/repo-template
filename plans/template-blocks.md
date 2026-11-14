# Plan: Keep template lines apart from project lines

## Goal

Each template file keeps the template's lines apart from a project's own, so a merge, by hand or by copier, can apply a template change without touching the project's lines.

## How each file does it

- **`cspell.json`** can `import` another config, so the template's settings sit in a file of their own and the project's `cspell.json` holds only its words.
- **`.gitignore`, `.gitattributes`, and `.pre-commit-config.yaml`** have no include. A block of the template's lines at the top, with the project's below, lets a three-way merge apply a template change without touching the project's lines.

## Steps

- [ ] Move the template's cspell settings into a file of their own, and have `cspell.json` import it.
- [ ] Mark off the template's block at the top of `.gitignore`, `.gitattributes`, and `.pre-commit-config.yaml`, with a place below for the project's lines.

## Docs to update

- [ ] `README.md`: say where a project adds its own lines in each file.

## Updates to send

- [ ] dotfiles' repo-template-check skill: it compares these files, so it should know the block layout, once the steps land.

## Done when

A project's own words and ignore lines sit outside the template's part of every file, and a `diff` against `template/` shows only that part.
