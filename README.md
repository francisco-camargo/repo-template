# repo-template

The files a new repo starts with: ignore rules, line-ending rules, commit gates, and a security policy.
Without a shared copy, each of these gets rewritten by hand in every project, and each copy drifts from the last.

## Use it

Copy the contents of `template/` into a project, new or existing:

```sh
git clone https://github.com/francisco-camargo/repo-template.git ~/git/repo-template
cp -rn ~/git/repo-template/template/. my-project/
```

`-n` skips any file the project already has, so running it in an existing project adds what is missing and replaces nothing.
To see how a file you kept differs from the template's, `diff` the two.

Then, inside the project:

```sh
pre-commit install
```

Some protection lives in GitHub's settings rather than in files, and no copy can turn it on.
For a public repo, turn on push protection and a branch ruleset; [dotfiles' security notes](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md#four-layers-and-what-each-one-misses) have the commands.

## Why the files sit in `template/`

Everything a project receives lives in `template/`, and everything about this repo lives outside it.
So this README, the TODO, and any tests of the template never land in a project.

## Work on this repo

This repo runs the template's own commit gates, from their place in `template/`:

```sh
pre-commit install -c template/.pre-commit-config.yaml
```

`scripts/check-anchors.sh` at the root only passes the call on to the copy in `template/`, so that the hook's path works both here and in a project.

## Where the files came from

They started in [dotfiles](https://github.com/francisco-camargo/dotfiles), which holds one person's machine configuration.
Files meant for every project do not belong there, so they moved here, and dotfiles is to take them from this repo like any other project.
The reasons behind the commit gates are in [dotfiles' security notes](https://github.com/francisco-camargo/dotfiles/blob/main/docs/security.md).

## Open items

### Consider copier

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
- **`_message_after_copy`** is text printed at the end, which is where the GitHub settings above would go.

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

### Decide whether the anchor check belongs in every project

dotfiles' pre-commit config runs a script that fails a commit when a Markdown link points at a heading that is not there.
dotfiles called it specific to that repo.
Every project that starts here has a README, and most will link within it, which argues for including it.

### Split global excludes from per-project ignores

dotfiles plans a global `core.excludesFile`, which would make a copied `.gitignore` partly unnecessary.
The line between them: OS clutter such as `.DS_Store` concerns one person's machine and belongs in the global file; credentials and build output protect everyone who clones a project and belong in its `.gitignore`.

### Decide whether copying runs git init and pre-commit install

Today a person copies the files and then runs `pre-commit install` by hand.
If copier is adopted, its `_tasks` could run `git init` and `pre-commit install` as part of the copy.
Those tasks only run with `--trust`, which asks the user to trust the template with a shell.
Printing the commands in `_message_after_copy` instead avoids that, and costs the user two lines of typing.
