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

## Pull requests

- Keep changes focused; one concern per pull request.
- Describe the motivation and any API changes.
- Ensure CI is green.
