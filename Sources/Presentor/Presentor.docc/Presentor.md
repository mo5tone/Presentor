# ``Presentor``

Presentor is a lightweight wrapper around the iOS custom view controller
presentation API. It presents any `UIViewController` as a sized and positioned
modal without hand-writing a `UIPresentationController` and transitioning
delegate.

## Overview

Configure a `Presentation` value, then present:

```swift
var presentation = Presentation.popup
presentation.transition = .coverVertical
presentation.behavior.dismissOnSwipe = true

present(MyViewController(), using: presentation, animated: true)
```

The presentation's transitioning delegate is retained for the lifetime of the
presented view controller, so no presenter object needs to be held.

## Topics

### Essentials

- <doc:MigratingFromPresentr>
- ``Presentation``
- ``Appearance``
- ``Behavior``
- ``Transition``

### Sizing and positioning

- ``ModalSize``
- ``ModalDimension``
- ``ModalPosition``

### Visuals

- ``RoundedCorners``
- ``Corners``
- ``PresentorShadow``

### Interaction

- ``BackgroundTapAction``
- ``DismissSwipeDirection``
- ``KeyboardTranslation``
- ``PresentorDelegate``

### Custom animations

- ``PresentationAnimation``
- ``AnimationTiming``
- ``PresentorTransitionContext``
