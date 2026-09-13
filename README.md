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
`SECURITY.md` sends reports through GitHub's private vulnerability reporting, which is off until you turn it on:

```sh
gh api -X PUT repos/<owner>/<repo>/private-vulnerability-reporting
```

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

What could come next, and the case for each, is in [TODO.md](TODO.md).
