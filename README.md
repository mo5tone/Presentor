# Presentor

Presentor is a modern, lightweight wrapper around the iOS custom view controller
presentation API. It presents any `UIViewController` as a sized and positioned
modal — alert, popup, top/bottom half, bottom card, full screen, or a fully custom
frame — without hand-writing a `UIPresentationController` and transitioning
delegate every time.

Presentor is derived from [Presentr](https://github.com/IcaliaLabs/Presentr) (MIT),
rebuilt for iOS 15+ / Swift 5.9 with value-type configuration, async/await, and
SwiftUI support.

## Requirements

- iOS 15.0+
- Swift 5.9+

## Installation

Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/mo5tone/Presentor.git", from: "1.0.0")
]
```

## Quick start

Configure a `Presentation` value and hand it to `present`:

```swift
import Presentor

var presentation = Presentation.popup
presentation.transition = .coverVertical
presentation.appearance.backgroundOpacity = 0.7
presentation.behavior.dismissOnSwipe = true

let controller = MyViewController()
present(controller, using: presentation, animated: true)
```

Async:

```swift
await present(controller, using: .alert, animated: true)
```

The presentation's transitioning delegate is retained for the lifetime of the
presented controller, so — unlike Presentr — there is no presenter object to hold
onto.

## SwiftUI

```swift
Button("Show") { isPresented = true }
    .presentor(isPresented: $isPresented, presentation: .popup) {
        MyView()
    }
```

Or driven by an item:

```swift
.presentor(item: $selectedItem, presentation: .bottomCard) { item in
    DetailView(item: item)
}
```

## Presets

| Preset | Size | Position | Notes |
|---|---|---|---|
| `.alert` | 270 × 180 | center | rounded corners |
| `.popup` | default | center | rounded corners |
| `.topHalf` | full × half | top | slides down from top |
| `.bottomHalf` | full × half | bottom | |
| `.fullScreen` | full × full | center | |
| `.bottomCard` | full × 350 | bottom edge | top rounded corners + swipe indicator |
| `.dynamic(position:)` | Auto Layout | configurable | sizes to content |

## Configuration

```swift
var presentation = Presentation.popup

// Size and position
presentation.size = ModalSize(width: .percent(0.9), height: .fixed(320))
presentation.position = .edge(.bottom(padding: 0))

// Appearance
presentation.appearance.backgroundColor = .black
presentation.appearance.blur = .system(.dark)
presentation.appearance.roundedCorners = RoundedCorners(.top, radius: 16)
presentation.appearance.shadow = PresentorShadow(color: .black, opacity: 0.3,
                                                 offset: CGSize(width: 0, height: 4),
                                                 radius: 12)

// Behavior
presentation.behavior.backgroundTap = .dismiss
presentation.behavior.dismissOnSwipe = true
presentation.behavior.dismissOnSwipeDirection = .down
presentation.behavior.keyboardTranslation = .moveUp
presentation.behavior.context = splitViewController   // presentation context
```

### Sizes

`ModalDimension` describes a single axis: `.default`, `.half`, `.full`, `.fixed(_)`,
`.percent(_)`, `.padding(_)`, `.orientation(portrait:landscape:)`, `.automatic`.

### Transitions

Built-ins: `.crossDissolve`, `.coverVertical`, `.coverVerticalFromTop`,
`.coverHorizontalFromRight`, `.coverHorizontalFromLeft`, `.flipHorizontal`,
`.coverFromCorner(_)`.

Custom animations subclass `PresentationAnimation`:

```swift
let animation = CoverVerticalAnimation(timing: .spring(duration: 0.6, delay: 0,
                                                       damping: 0.7, velocity: 0))
presentation.transition = .custom(animation)
```

Override `transform(containerFrame:finalFrame:)` for simple movement, or
`beforeAnimation`/`performAnimation`/`afterAnimation` for full control.

## Delegate

Conform a presented view controller (or its visible navigation child) to
`PresentorDelegate` to observe or prevent dismissal:

```swift
func presentorShouldDismiss(keyboardShowing: Bool) -> Bool
```

## Migrating from Presentr

| Presentr | Presentor |
|---|---|
| `Presentr(presentationType:)` (must be retained) | `Presentation` value passed to `present(_:using:)` |
| `customPresentViewController(_:viewController:animated:completion:)` | `present(_:using:animated:completion:)` |
| `presenter.transitionType` | `presentation.transition` |
| `presenter.dismissTransitionType` | `presentation.dismissTransition` |
| `presenter.roundCorners` / `cornerRadius` | `presentation.appearance.roundedCorners` |
| `presenter.dropShadow` | `presentation.appearance.shadow` |
| `presenter.backgroundColor` / `backgroundOpacity` | `presentation.appearance.backgroundColor` / `.backgroundOpacity` |
| `presenter.blurBackground` / `blurStyle` | `presentation.appearance.blur` |
| `presenter.dismissOnSwipe` / `dismissOnSwipeDirection` | `presentation.behavior.dismissOnSwipe` / `.dismissOnSwipeDirection` |
| `presenter.keyboardTranslationType` | `presentation.behavior.keyboardTranslation` |
| `presenter.viewControllerForContext` | `presentation.behavior.context` |
| `BackgroundTapAction.noAction` | `BackgroundTapAction.none` |
| `DismissSwipeDirection.default/.bottom/.top` | `.automatic/.down/.up` |
| `PresentationType` | `Presentation` presets |
| `ModalSize` | `ModalDimension` + `ModalSize` |
| `ModalCenterPosition` | `ModalPosition` |
| `TransitionType` | `Transition` |
| `PresentrAnimation` / `AnimationOptions` | `PresentationAnimation` / `AnimationTiming` |
| `PresentrDelegate` | `PresentorDelegate` |
| `AlertViewController` | not included — use your own controller |

## Testing

Logic tests use [Swift Testing](https://developer.apple.com/xcode/swift-testing/):

```sh
xcodebuild test -scheme Presentor -destination 'platform=iOS Simulator,name=iPhone 17'
```

Image snapshots live in the example app's test target because UIKit presentations
need a live window scene (a plain SwiftPM logic-test host does not provide one):

```sh
brew install xcodegen
cd Example && xcodegen generate
xcodebuild test -project Example/PresentorExample.xcodeproj -scheme PresentorExample \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

Snapshot references are recorded on a specific simulator/runtime. Re-record after
intentional visual changes with `withSnapshotTesting(record: .all) { ... }`.

## Credits

Presentor is based on **Presentr** by Daniel Lozano Valdes and the Icalia Labs
community. See `NOTICE.md` for details.

## License

MIT. See `LICENSE`.
