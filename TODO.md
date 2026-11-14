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

## Split global excludes from per-project ignores

dotfiles plans a global `core.excludesFile`, which would make a copied `.gitignore` partly unnecessary.
The line between them: OS clutter such as `.DS_Store` concerns one person's machine and belongs in the global file; credentials and build output protect everyone who clones a project and belong in its `.gitignore`.

## Let `.env.template` through `.gitignore`

The template ignores `.env.*` and lets only `.env.example` through.
Some projects name the same file `.env.template`.
Git keeps tracking one already committed, but a new one stays ignored.
Either add `!.env.template`, or rename the file to `.env.example` when a project takes the template.

## Run the gates over the other repos' files

- [Run the gates over old files](plans/gates-over-old-files.md): `pre-commit run --all-files` in each repo

## Add the files the template still lacks

- [Add missing files](plans/missing-files.md): README skeleton, LICENSE, Python files, `.claude/settings.json`

## Run the gates in CI

- [Run the gates in CI](plans/gates-in-ci.md): run pre-commit on every push and settle whether lychee stays

## Point francisco-camargo's notes here

[francisco-camargo](https://github.com/francisco-camargo/francisco-camargo) keeps learning notes, and some of them describe files this repo provides: the project-structure list in its Python notes, and `.gitattributes` in its git notes.
As each lands here, replace the matching part of those notes with a link to this repo, so the files live in one place.

## Move the shared docs out of dotfiles

- [Move shared docs out of dotfiles](plans/shared-docs.md): security notes and spelling move here; keep dotfiles' copies in step until then
