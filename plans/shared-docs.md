# Plan: Move the shared docs out of dotfiles

## Goal

The docs about any project, not one person's machines, live here next to the files they explain, and dotfiles takes its shared files from `template/` like any other project.

## What moves

From dotfiles' [docs/security.md](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md), each section moves here and leaves a link behind:

- [Commit the reference, not the secret](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#commit-the-reference-not-the-secret)
- [Git history does not forget](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#git-history-does-not-forget)
- [The commit gates](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#the-commit-gates)
- [Four layers, and what each one misses](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#four-layers-and-what-each-one-misses)
- [Repo-local hooks, or global, and the trap in the global one](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#repo-local-hooks-or-global-and-the-trap-in-the-global-one)

From dotfiles' plans, to become a plan here:

- [Settle how spelling gets checked](https://github.com/francisco-camargo/dotfiles/blob/main/plans/spelling.md)

dotfiles keeps only what concerns its owner's machines, such as its cspell word list.

## Keep dotfiles' copies in step until then

dotfiles still has its own copies of the files `template/` started from: `.gitattributes`, `.gitignore`, `.markdownlint.yaml`, `.pre-commit-config.yaml`, `SECURITY.md`, `_typos.toml`, and `cspell.json`.
Nothing checks that the copies match, so a change to either copy needs the same change in the other, as a commit in each repo.

`diff` each pair to find drift.
These differences are meant to be there:

- **`cspell.json` and `_typos.toml`:** dotfiles has its own words.
- **`SECURITY.md`:** dotfiles links to its security notes.

This rule ends with the last step below.

## Steps

- [ ] Move "Commit the reference, not the secret" here, and link to it from dotfiles.
- [ ] Move "Git history does not forget" here, and link to it from dotfiles.
- [ ] Move "The commit gates" here, and link to it from dotfiles.
- [ ] Move "Four layers, and what each one misses" here, and link to it from dotfiles.
- [ ] Move "Repo-local hooks, or global" here, and link to it from dotfiles.
- [ ] Move dotfiles' spelling plan into `plans/` here, and delete it from dotfiles.
- [ ] Settle where the `.claude.json` and `.credentials.json` ignore lines live.
- [ ] Have dotfiles take its shared files from `template/`, keeping only its own words and security link.

## Docs to update

- [ ] `README.md`: link to the moved security sections.
- [ ] `template/SECURITY.md`: link to the moved sections rather than to dotfiles.
- [ ] dotfiles' `docs/security.md`: a link here in place of each moved section.
- [ ] dotfiles' [spelling plan](https://github.com/francisco-camargo/dotfiles/blob/main/plans/spelling.md): its Docs to update line names this plan.

## Updates to send

None.

## Open questions

- Where do the `.claude.json` and `.credentials.json` lines in `template/.gitignore` belong? They concern dotfiles alone. I lean towards moving them into dotfiles' own `.gitignore`, below the template's block.

## Done when

dotfiles' shared files differ from `template/` only in the ways listed above, and dotfiles' `docs/security.md` keeps no section about projects in general.
