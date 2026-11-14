# Plan: Run the gates over the other repos' files

## Goal

Every file in every repo that took the template passes its gates, not only the files committed since.

## Why

The gates check only the files a commit stages, so a file nobody has touched since the gates arrived still fails them.
francisco-camargo's notes fail markdownlint the most; the gb-* repos fail it a few times each.

## Steps

In each repo, run `pre-commit run --all-files`, commit what it fixes, and fix the rest by hand.

- [ ] francisco-camargo
- [ ] gb-after-school-program
- [ ] gb-financial-transactions
- [ ] gb-flyers
- [ ] gb-roles-and-responsibilities
- [ ] gb-westlake-company-agreement

## Docs to update

None.

## Updates to send

None.

## Done when

`pre-commit run --all-files` passes in each repo above.
