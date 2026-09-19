# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[1.0.0]: https://github.com/mo5tone/Presentor/releases/tag/v1.0.0
