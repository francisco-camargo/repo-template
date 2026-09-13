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
Overwriting loses the repo's own lines, so they would have to be merged back by hand once, and dotfiles' [repo-template-check skill](https://github.com/francisco-camargo/dotfiles/tree/main/claude/skills/repo-template-check) would show which ones.
That needs a trial run before anything relies on it, and dotfiles is the first project to try it on.

The decision turns on how many projects use this repo and how often the files change.
With a few projects and rare changes, `cp -rn` and a `diff` are enough.
Once fixes keep failing to reach projects, copier earns its cost.

## Keep template lines apart from project lines

Once a repo adds lines of its own to a template file, any merge, by hand or by copier, has to tell the two apart.

- **`cspell.json`** can `import` another config, so the template's settings could sit in a file of their own and the project's `cspell.json` hold only its words.
- **`.gitignore`, `.gitattributes`, and `.pre-commit-config.yaml`** have no include. A block of the template's lines at the top, with the project's below, lets a three-way merge apply a template change without touching the project's lines.

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

## Offer `SECURITY.md` only to public repos

`SECURITY.md` sends reports through private vulnerability reporting, which GitHub offers only on public repos.
In a private repo it points at a channel that does not exist.
The check should offer it only to a public repo, and under copier it would be a question.

## Decide whether copying runs git init and pre-commit install

Today a person copies the files and then runs `pre-commit install` by hand.
If copier is adopted, its `_tasks` could run `git init` and `pre-commit install` as part of the copy.
Those tasks only run with `--trust`, which asks the user to trust the template with a shell.
Printing the commands in `_message_after_copy` instead avoids that, and costs the user two lines of typing.

## Add the files the template still lacks

- **`README.md`**, a skeleton for the project to fill in. `cp -rn` already leaves a project's own README alone.
- **`LICENSE`**, a choice of license or none. The choice is a question, so without copier each project picks its own.
- **A Python layer for `.pre-commit-config.yaml`**, from the Python config in [francisco-camargo/francisco-camargo](https://github.com/francisco-camargo/francisco-camargo). Only a Python project wants it, which is also a question.
- **The rest of a Python project**: `pyproject.toml` from `uv init`, `src/` and `tests/` directories, and `.venv/` and `__pycache__/` in `.gitignore`. It rides on the same question as the Python layer.
- **`.claude/settings.json`**, the project-level route to the Claude Code gates, from dotfiles' [Merge `settings.json` instead of replacing it](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#merge-settingsjson-instead-of-replacing-it). Whether to include it is a question too.

## Run the gates in CI

The gates run only in a clone where someone ran `pre-commit install`, so a commit made anywhere else skips them.
A workflow under `.github/workflows/` that runs `pre-commit run --all-files` on every push and pull request catches those commits, after the fact but before a merge.
It would also be the first place lychee's download runs on Linux, so check that it works there.

## Add a `.markdownlint.yaml`

[francisco-camargo](https://github.com/francisco-camargo/francisco-camargo)'s Markdown notes keep one for the markdownlint VS Code extension.
It turns off the line length rule (MD013), which one sentence per line needs.
It also sets nested list indents to 4 spaces (MD007), which disagrees with the 2 spaces `.editorconfig` sets, so settle that before copying it.

The extension only lints in the editor.
A markdownlint hook would enforce the rules at commit time, and its MD051 rule would overlap lychee's check of links within a file.

## Decide whether `.editorconfig` earns its place

`.editorconfig` tells an editor how to write a file: line endings, a final newline, trailing whitespace, and indentation.
Other files and settings already cover most of that:

- **`.gitattributes`** stores text files with LF, whatever the editor writes.
- **The commit gates** fix a missing final newline and trailing whitespace before a commit lands.
- **VS Code's user settings** set line endings, trimming, and indents, but only on one person's machine. dotfiles could carry them.
- **A project's `.vscode/settings.json`** sets the same for everyone who opens the repo in VS Code.
- **A formatter**, such as ruff in the planned Python layer, owns indentation in the files it formats.
- **`.markdownlint.yaml`**, if added, sets Markdown list indents, and its value disagrees with `.editorconfig`'s.

What `.editorconfig` alone does is get a file right as it is written, in any editor, for anyone.
Against it: VS Code ignores the file without the EditorConfig extension, and with the extension, the file's `indent_size` overrides a user's `editor.tabSize` without saying so.

Decide which place owns each setting, then keep `.editorconfig`, cut it to what nothing else covers, or drop it.

## Decide whether `.gitattributes` marks binaries

francisco-camargo's `.gitattributes` marks images and PDFs as `binary`.
With `* text=auto eol=lf`, git already detects binary files and leaves their line endings alone, so explicit rules add little.
They help with a file type git misdetects.
PDFs are the likeliest: git decides from the first 8000 bytes, and a PDF can open with that much plain text.
They hurt with `*.svg`, which is text: marking it binary hides its diffs.
Leave them out until a file gets mangled.

## Point francisco-camargo's notes here

[francisco-camargo](https://github.com/francisco-camargo/francisco-camargo) keeps learning notes, and some of them describe files this repo provides: the project-structure list and pre-commit config in its Python notes, `.gitattributes` in its git notes, and `.markdownlint.yaml` in its Markdown notes.
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

From dotfiles' open items, to become open items here:

- [Consolidate the two pre-commit configs](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#consolidate-the-two-pre-commit-configs)
- [Settle how spelling gets checked](https://github.com/francisco-camargo/dotfiles/blob/main/TODO.md#settle-how-spelling-gets-checked)

After that, dotfiles takes its shared files from `template/` like any other project, and keeps only what concerns its owner's machines, such as its cspell word list.
Until then, [keep dotfiles' copies in step](#keep-dotfiles-copies-in-step-until-it-takes-them-from-here).
Its planned `SECURITY.md` would come from here too.
The template's `.gitignore` still carries dotfiles' `.claude.json` and `.credentials.json` lines, which belong to dotfiles alone; the move is the time to settle where they live.

## Keep dotfiles' copies in step until it takes them from here

dotfiles still has its own copies of the files `template/` started from: `.gitattributes`, `.gitignore`, `.pre-commit-config.yaml`, and `cspell.json`.
Nothing checks that the copies match, so a change to either copy needs the same change in the other, as a commit in each repo.

`diff` each pair to find drift.
These differences are meant to be there:

- **`.gitignore`:** the template lets `.env.example` through, and dotfiles has no such file.
- **`.pre-commit-config.yaml`:** dotfiles' header comment mentions its `install.sh`.
- **`cspell.json`:** dotfiles has its own word list.

This item ends when dotfiles [takes the files from here](#move-the-shared-docs-out-of-dotfiles).
