# Migrating from Presentr

Presentor is based on Presentr but modernizes the API. The biggest change is that
configuration is a value type (`Presentation`) passed to a present call, instead
of a retained `Presentr` object.

## Before and after

```swift
// Presentr
let presenter = Presentr(presentationType: .alert)   // must be retained
presenter.transitionType = .coverVerticalFromTop
presenter.dismissOnSwipe = true
customPresentViewController(presenter, viewController: vc, animated: true)

// Presentor
var presentation = Presentation.alert
presentation.transition = .coverVerticalFromTop
presentation.behavior.dismissOnSwipe = true
present(vc, using: presentation, animated: true)
```

## Type mapping

| Presentr | Presentor |
|---|---|
| `Presentr(presentationType:)` | `Presentation` value |
| `customPresentViewController(_:viewController:animated:completion:)` | `present(_:using:animated:completion:)` |
| `transitionType` / `dismissTransitionType` | `transition` / `dismissTransition` |
| `roundCorners` / `cornerRadius` | `appearance.roundedCorners` |
| `dropShadow` | `appearance.shadow` |
| `backgroundColor` / `backgroundOpacity` | `appearance.backgroundColor` / `.backgroundOpacity` |
| `blurBackground` / `blurStyle` | `appearance.blur` |
| `customBackgroundView` | `appearance.customBackgroundView` |
| `dismissOnSwipe` / `dismissOnSwipeDirection` | `behavior.dismissOnSwipe` / `.dismissOnSwipeDirection` |
| `dismissAnimated` | `behavior.dismissAnimated` |
| `keyboardTranslationType` | `behavior.keyboardTranslation` |
| `viewControllerForContext` | `behavior.context` |
| `PresentationType` | `Presentation` presets |
| `ModalSize` | `ModalDimension` + `ModalSize` |
| `ModalCenterPosition` | `ModalPosition` |
| `TransitionType` | `Transition` |
| `PresentrAnimation` / `AnimationOptions` | `PresentationAnimation` / `AnimationTiming` |
| `PresentrDelegate` | `PresentorDelegate` |

## Removed

- `AlertViewController`, its xib, and the bundled Montserrat / SourceSansPro fonts.
  Bring your own controller.
- `BackgroundTapAction.noAction` became `.none`.
- `DismissSwipeDirection.default/.bottom/.top` became `.automatic/.down/.up`.
