# Notice

Presentor is a derivative work based on **Presentr**.

- Presentr: https://github.com/IcaliaLabs/Presentr
- Original author: Daniel Lozano Valdes and Icalia Labs contributors
- License: MIT (see `LICENSE`)

## What was retained

- The public concept of a custom `UIPresentationController` wrapper for sized/positioned modals.
- The sizing/position math (`ModalSize`, `ModalCenterPosition`) and its constants.
- The transition-animation architecture and the transform math of the built-in animations.
- Keyboard translation frame math.
- The `PresentrDelegate` idea and `BackgroundTapAction` behavior.

## What was changed

- Rebuilt from Presentr `master` (v1.9) as a SwiftPM-only package targeting iOS 15+.
- Replaced the reference-type `Presentr` configuration object with the value-type `Presentation`.
- Renamed and reorganized types; removed the bundled `AlertViewController`, its xib, and bundled fonts.
- Rewrote the presentation controller, gesture handling, keyboard observation, and added async/await and SwiftUI entry points.
- Removed all `#if swift(...)` compatibility shims and `UIScreen.main` usage.
