# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0](https://github.com/mo5tone/Presentor/compare/1.1.0...2.0.0) (2026-10-01)


### ⚠ BREAKING CHANGES

* consumers on Swift 5.10 / Xcode 15.4 or earlier can no longer resolve the package. Swift 6.0+ (Xcode 16+) is required. The iOS 15 deployment target is unchanged.

### Features

* adopt swift 6 language mode with a swift 5.10 compatibility manifest ([d0f3b04](https://github.com/mo5tone/Presentor/commit/d0f3b0499b31d6a19017ba0ee45470929987ce02))


### Build System

* require Swift 6 toolchains ([aee159f](https://github.com/mo5tone/Presentor/commit/aee159fbe63c2414f1d052f9ddc2a422d484ee0c))

## [1.1.0](https://github.com/mo5tone/Presentor/compare/1.0.0...1.1.0) (2026-09-19)


### Features

* **example:** add floating card customization example ([c90c7b2](https://github.com/mo5tone/Presentor/commit/c90c7b21149c73fa8a4b290397150471ae33cce7))
* **transitions:** zoom alert and popup presets ([bf9cffd](https://github.com/mo5tone/Presentor/commit/bf9cffd9b0db0cccb5b6cf73cdd1277fa73a6768))


### Bug Fixes

* **swiftui:** size dynamic presentations to SwiftUI content ([8e6f00b](https://github.com/mo5tone/Presentor/commit/8e6f00bc0ac6092461c356046f7c1064302f17e2))

## [1.0.0] - 2026-09-19

### Added
- `Presentation` value type with presets: `.alert`, `.popup`, `.topHalf`,
  `.bottomHalf`, `.fullScreen`, `.bottomCard`, and `.dynamic(position:)`.
- UIKit entry points: `present(_:using:animated:completion:)` and an `async` variant,
  plus `dismissPresented(animated:) async`.
- SwiftUI modifiers: `presentor(isPresented:presentation:content:)` and
  `presentor(item:presentation:content:)`.
- `Appearance` and `Behavior` configuration, `ModalSize`/`ModalDimension`,
  `ModalPosition`, `RoundedCorners`, `PresentorShadow`, and `KeyboardTranslation`.
- Built-in transitions and the `PresentationAnimation` base class for custom animations.
- Swipe-to-dismiss with an optional indicator, and keyboard translation.
- Swift Testing logic tests and app-hosted image snapshot tests.

### Changed
- Rebuilt from Presentr's `master` (v1.9) as a SwiftPM-only package targeting iOS 15+.

### Removed
- The bundled `AlertViewController`, its xib, and bundled fonts.

[1.0.0]: https://github.com/mo5tone/Presentor/releases/tag/1.0.0
