# TODO

What could come next, and the case for each.
Delete an item once it is done.

## Consider copier

Copying `template/` by hand has two limits.
It cannot ask a question, so a Python project and a shell project get the same files.
And a project has no link back, so a fix made here never reaches a project that copied an earlier version.

[Copier](https://copier.readthedocs.io/) removes both.
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

**How a template is built.**

- **`copier.yml`** at the root holds the questions and the settings.
- **`_subdirectory: template`** points copier at the directory this repo already uses, so adopting copier moves no files.
- **Files ending in `.jinja`** are rendered, so `README.md.jinja` can use the project name from an answer. Files without the suffix are copied as they are.
- **Jinja in a file name** makes a file conditional on an answer, such as a Python layer of the pre-commit config that only appears in a Python project.
- **`_skip_if_exists`** names files a project owns once they exist, such as `README.md`.
- **`_tasks`** lists commands to run after copying, such as `git init` and `pre-commit install`. Copier refuses to run them unless the user passes `--trust`, which asks the user to trust the template with a shell.
- **`_message_after_copy`** is text printed at the end, which is where the GitHub settings in [Use it](README.md#use-it) would go.

**How updating works.**
A project records its answers, and the template version it came from, in `.copier-answers.yml`, which gets committed.
`copier update` needs, in copier's words, a project that "includes a valid .copier-answers.yml file", a template "versioned with Git (with tags)", and a project "versioned with Git", with a clean `git status`.
It then does a three-way merge between the old template version, the new one, and the project as it stands.
A conflict shows up as inline markers, the same as in a `git merge`.

**What it costs.**

- **Python**, 3.10 or newer, though `uvx` fetches it for a person running one command.
- **Jinja is harder to read** than a plain file. Keeping `.jinja` to the files that need an answer limits that.
- **Releases need tags.** A fix is not available to `copier update` until it is tagged.
- **GitHub's "Use this template" button stops being useful**, because it would copy `copier.yml` and raw `.jinja` files.

**Not yet known.**
Copier's documentation says little about taking over a project it did not create.
Running `copier copy` into an existing repo should ask before overwriting each file that differs, then write `.copier-answers.yml`, after which `copier update` works.
That needs a trial run before anything relies on it, and dotfiles is the first project to try it on.

The decision turns on how many projects use this repo and how often the files change.
With a few projects and rare changes, `cp -rn` and a `diff` are enough.
Once fixes keep failing to reach projects, copier earns its cost.

## Decide whether the anchor check belongs in every project

dotfiles' pre-commit config runs a script that fails a commit when a Markdown link points at a heading that is not there.
dotfiles called it specific to that repo.
Every project that starts here has a README, and most will link within it, which argues for including it.

## Skip links inside inline code in the anchor check

`scripts/check-anchors.sh` ignores links inside fenced code blocks, but still checks a link written inside backticks, as an example of Markdown syntax.
GitHub renders that as text, so a broken anchor there fails a commit for nothing.
This item hit it: an example here had to become a description.
A fix has to handle spans that cross lines and backtick runs of different lengths, so it waits until a description will not do.
Make the change in dotfiles' copy too, while [the copies are kept in step](#keep-dotfiles-copies-in-step-until-it-takes-them-from-here).

## Consider publishing the anchor check as a pre-commit hook

Today every repo that runs the anchor check keeps its own copy of the script, so a fix is a commit in each, and nothing notices when the copies drift.

Installing the script machine-wide from dotfiles would not fix that.
A repo's `.pre-commit-config.yaml` is committed, so a hook that calls a script only your machines have fails for anyone else who clones the repo, and in CI.

pre-commit's own answer is a hook published from one repo.
This repo would carry a `.pre-commit-hooks.yaml`:

```yaml
- id: check-anchors
  name: Markdown anchors resolve
  entry: template/scripts/check-anchors.sh
  language: script
  files: \.md$
  pass_filenames: false
```

and each repo that wants the check would pin a version of it, as it does for gitleaks:

```yaml
- repo: https://github.com/francisco-camargo/repo-template
  rev: v0.1.0
  hooks:
    - id: check-anchors
```

**What it gains.**

- **One copy.** A fix is one commit and a tag, and dotfiles' copy, `template/scripts/`, and the root wrapper script all go away.
- **Upgrades are visible.** Each repo moves with `pre-commit autoupdate`, and its `rev` line says which version it runs.
- **Nothing to install.** Whoever clones a repo gets the hook the way they get gitleaks.

**What it costs.**

- **Publishing is a promise.** Once a tag is public, other repos may pin it, so a change to the hook's id, its arguments, or what it accepts can break them.
- **Releases need tags.** Copier would need them too.
- **Testing a change before tagging it** takes `pre-commit try-repo . check-anchors --all-files`.
- **`language: script` runs with the machine's `bash`.** That holds today as well, but a run on Windows should confirm it before anything relies on it.

If more shared hooks turn up, a repo of their own would suit them better than this one.

## Split global excludes from per-project ignores

dotfiles plans a global `core.excludesFile`, which would make a copied `.gitignore` partly unnecessary.
The line between them: OS clutter such as `.DS_Store` concerns one person's machine and belongs in the global file; credentials and build output protect everyone who clones a project and belong in its `.gitignore`.

## Decide whether copying runs git init and pre-commit install

Today a person copies the files and then runs `pre-commit install` by hand.
If copier is adopted, its `_tasks` could run `git init` and `pre-commit install` as part of the copy.
Those tasks only run with `--trust`, which asks the user to trust the template with a shell.
Printing the commands in `_message_after_copy` instead avoids that, and costs the user two lines of typing.

## Add the files the template still lacks

- **`README.md`**, a skeleton for the project to fill in. `cp -rn` already leaves a project's own README alone.
- **`LICENSE`**, a choice of license or none. The choice is a question, so without copier each project picks its own.
- **A Python layer for `.pre-commit-config.yaml`**, from the Python config in [francisco-camargo/francisco-camargo](https://github.com/francisco-camargo/francisco-camargo). Only a Python project wants it, which is also a question.
- **`.claude/settings.json`**, the project-level route to the Claude Code gates, from dotfiles' [Merge `settings.json` instead of replacing it](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#merge-settingsjson-instead-of-replacing-it). Whether to include it is a question too.

## Move the shared docs out of dotfiles

Part of dotfiles' documentation is about any project, not one person's machines, and belongs here next to the files it explains.
Each of these would move here and leave a link behind.

From dotfiles' [docs/security.md](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md):

- [Commit the reference, not the secret](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#commit-the-reference-not-the-secret)
- [Git history does not forget](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#git-history-does-not-forget)
- [The commit gates](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#the-commit-gates)
- [Four layers, and what each one misses](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#four-layers-and-what-each-one-misses)
- [Repo-local hooks, or global, and the trap in the global one](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#repo-local-hooks-or-global-and-the-trap-in-the-global-one)

From dotfiles' open items, to become open items here:

- [Consolidate the two pre-commit configs](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#consolidate-the-two-pre-commit-configs)
- [Settle how spelling gets checked](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#settle-how-spelling-gets-checked)

After that, dotfiles takes its shared files from `template/` like any other project, and keeps only what concerns its owner's machines, such as its cspell word list.
Until then, [keep dotfiles' copies in step](#keep-dotfiles-copies-in-step-until-it-takes-them-from-here).
Its planned `SECURITY.md` would come from here too.
The template's `.gitignore` still carries dotfiles' `.claude.json` and `.credentials.json` lines, which belong to dotfiles alone; the move is the time to settle where they live.

## Keep dotfiles' copies in step until it takes them from here

dotfiles still has its own copies of the files `template/` started from: `.gitattributes`, `.gitignore`, `.pre-commit-config.yaml`, `cspell.json`, and `scripts/check-anchors.sh`.
Nothing checks that the copies match, so a change to either copy needs the same change in the other, as a commit in each repo.

`diff` each pair to find drift.
These differences are meant to be there:

- **`.gitignore`:** the template lets `.env.example` through, and dotfiles has no such file.
- **`.pre-commit-config.yaml`:** dotfiles' header comment mentions its `install.sh`.
- **`cspell.json`:** dotfiles has its own word list.

This item ends when dotfiles [takes the files from here](#move-the-shared-docs-out-of-dotfiles).
