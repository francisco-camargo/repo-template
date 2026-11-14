# TODO

The work ahead, in priority order.
Each item links to its plan in [plans/](plans/) where it needs more than a line.

## Next

- [Move shared docs out of dotfiles](plans/shared-docs.md): security notes and spelling move here; keep dotfiles' copies in step until then
- [Run the gates in CI](plans/gates-in-ci.md): run pre-commit on every push and settle whether lychee stays

## Small tasks

- Tag a version whenever the template changes, so a project can record which one it took; `copier update` needs the tags too
- Add `!.env.template` to `.gitignore`, or rename the file to `.env.example` when a project takes the template, since a new `.env.template` stays ignored
- As each file lands here, replace the matching part of [francisco-camargo](https://github.com/francisco-camargo/francisco-camargo)'s notes (Python project structure, `.gitattributes`) with a link

## Later

- [Consider copier](plans/copier.md): generate and update projects from the template
- [Keep template lines apart](plans/template-blocks.md): so a merge can tell the template's lines from a project's
- [Add missing files](plans/missing-files.md): README skeleton, LICENSE, Python files, `.claude/settings.json`

## Ideas

- Once dotfiles has a global `core.excludesFile`, move OS clutter such as `.DS_Store` there; credentials and build output stay in each project's `.gitignore`
