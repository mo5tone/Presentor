# Contributing

Thanks for your interest in Presentor.

## Getting started

1. Fork and clone the repository.
2. Open the package or develop from the command line.

Because Presentor links UIKit, it cannot be built or tested with `swift test` on
macOS. Use `xcodebuild` against an iOS Simulator instead:

```sh
xcodebuild test -scheme Presentor -destination 'platform=iOS Simulator,name=iPhone 16'
```

To build only:

```sh
xcodebuild build -scheme Presentor -destination 'generic/platform=iOS Simulator'
```

## Guidelines

- Keep the public API value-based: configuration lives in `Presentation`.
- Add or update unit tests for any sizing, positioning, transition, or keyboard math.
- Run the formatter before opening a pull request: `swiftformat Sources Tests`.
- Update `CHANGELOG.md` for user-facing changes.

## Commit and PR conventions

This project follows [Conventional Commits](https://www.conventionalcommits.org/).
Pull request titles are linted in CI and, because PRs are squash-merged, the PR
title becomes the commit message.

```
<type>(<optional scope>): <description>

feat(presentation): add bottom sheet preset
fix(controller): keep frame when keyboard hides
docs: document keyboard translation
```

Allowed types: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`,
`revert`, `style`, `test`. The description must be lowercase and imperative.

## Pull requests

- Keep changes focused; one concern per pull request.
- Use a Conventional Commit title (see above); CI will reject otherwise.
- Describe the motivation and any API changes.
- Ensure CI is green.

## Releases and changelog

Releases are automated with [release-please](https://github.com/googleapis/release-please).
Do not edit `CHANGELOG.md` by hand or bump versions manually — release-please
reads the Conventional Commit history on `main` and opens a release PR that updates
`CHANGELOG.md` and the version tag. Merging that PR cuts the release.
