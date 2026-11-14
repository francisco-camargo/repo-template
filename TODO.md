# TODO

What could come next, and the case for each.
Delete an item once it is done.

## Split this file into plans

Move each item below into a plan in `plans/`, and leave one line here linking to it, as dotfiles' [planning skill](https://github.com/francisco-camargo/dotfiles/blob/main/claude/skills/planning/SKILL.md) lays out.

## Consider copier

- [Consider copier](plans/copier.md): generate and update projects from the template

## Keep template lines apart from project lines

- [Keep template lines apart](plans/template-blocks.md): so a merge can tell the template's lines from a project's

## Tag releases

Tag a version whenever the template changes, so a project can record which version it took.
`copier update` needs the tags too.

## Decide whether the link check belongs in every project

The template runs lychee, which fails a commit when a Markdown link points at a file or heading that is not there.
dotfiles first added a check like it as specific to that repo.
Every project that starts here has a README, and most will link within it, which argues for keeping it.
Against it: the first run downloads lychee through an installer that Windows may flag.

## Split global excludes from per-project ignores

dotfiles plans a global `core.excludesFile`, which would make a copied `.gitignore` partly unnecessary.
The line between them: OS clutter such as `.DS_Store` concerns one person's machine and belongs in the global file; credentials and build output protect everyone who clones a project and belong in its `.gitignore`.

## Let `.env.template` through `.gitignore`

The template ignores `.env.*` and lets only `.env.example` through.
Some projects name the same file `.env.template`.
Git keeps tracking one already committed, but a new one stays ignored.
Either add `!.env.template`, or rename the file to `.env.example` when a project takes the template.

## Run the gates over the other repos' files

Every repo has the template's gates, but the gates check only the files a commit stages, so a file nobody has touched since still fails them.
francisco-camargo's notes fail markdownlint the most; the gb-* repos fail it a few times each.
In each repo, run `pre-commit run --all-files`, commit what it fixes, and fix the rest by hand.

## Add the files the template still lacks

- **`README.md`**, a skeleton for the project to fill in. `cp -rn` already leaves a project's own README alone.
- **`LICENSE`**, a choice of license or none. The choice is a question, so without copier each project picks its own.
- **A Python project's files**: `pyproject.toml` from `uv init`, `src/` and `tests/` directories, and `.venv/` and `__pycache__/` in `.gitignore`. Only a Python project wants them, which is also a question.
- **`.claude/settings.json`**, the project-level route to the Claude Code gates, from dotfiles' [plan to make the gates easy to adopt](https://github.com/francisco-camargo/dotfiles/blob/main/plans/hook-scripts.md). Whether to include it is a question too.

## Run the gates in CI

The gates run only in a clone where someone ran `pre-commit install`, so a commit made anywhere else skips them.
A workflow under `.github/workflows/` that runs `pre-commit run --all-files` on every push and pull request catches those commits, after the fact but before a merge.
It would also be the first place lychee's download runs on Linux, so check that it works there.

## Point francisco-camargo's notes here

[francisco-camargo](https://github.com/francisco-camargo/francisco-camargo) keeps learning notes, and some of them describe files this repo provides: the project-structure list in its Python notes, and `.gitattributes` in its git notes.
As each lands here, replace the matching part of those notes with a link to this repo, so the files live in one place.

## Move the shared docs out of dotfiles

Part of dotfiles' documentation is about any project, not one person's machines, and belongs here next to the files it explains.
Each of these would move here and leave a link behind.

From dotfiles' [docs/security.md](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md):

- [Commit the reference, not the secret](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#commit-the-reference-not-the-secret)
- [Git history does not forget](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#git-history-does-not-forget)
- [The commit gates](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#the-commit-gates)
- [Four layers, and what each one misses](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#four-layers-and-what-each-one-misses)
- [Repo-local hooks, or global, and the trap in the global one](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#repo-local-hooks-or-global-and-the-trap-in-the-global-one)

From dotfiles' plans, to become open items here:

- [Settle how spelling gets checked](https://github.com/francisco-camargo/dotfiles/blob/main/plans/spelling.md)

After that, dotfiles takes its shared files from `template/` like any other project, and keeps only what concerns its owner's machines, such as its cspell word list.
Until then, [keep dotfiles' copies in step](#keep-dotfiles-copies-in-step-until-it-takes-them-from-here).
The template's `.gitignore` still carries dotfiles' `.claude.json` and `.credentials.json` lines, which belong to dotfiles alone; the move is the time to settle where they live.

## Keep dotfiles' copies in step until it takes them from here

dotfiles still has its own copies of the files `template/` started from: `.gitattributes`, `.gitignore`, `.markdownlint.yaml`, `.pre-commit-config.yaml`, `SECURITY.md`, `_typos.toml`, and `cspell.json`.
Nothing checks that the copies match, so a change to either copy needs the same change in the other, as a commit in each repo.

`diff` each pair to find drift.
These differences are meant to be there:

- **`cspell.json` and `_typos.toml`:** dotfiles has its own words.
- **`SECURITY.md`:** dotfiles links to its security notes.

This item ends when dotfiles [takes the files from here](#move-the-shared-docs-out-of-dotfiles).
