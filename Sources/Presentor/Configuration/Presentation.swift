//
//  Presentation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

/// A complete, value-type description of how a view controller should be presented.
///
/// Configure a `Presentation`, then pass it to
/// `UIViewController.present(_:using:animated:completion:)` or the async variant.
public struct Presentation {
    /// The width and height of the presented view.
    public var size: ModalSize
    /// Where the presented view is placed inside its container.
    public var position: ModalPosition
    /// The transition used when presenting.
    public var transition: Transition
    /// The transition used when dismissing. When `nil`, `transition` is used.
    public var dismissTransition: Transition?
    /// Visual configuration.
    public var appearance: Appearance
    /// Interaction configuration.
    public var behavior: Behavior

    public init(size: ModalSize = .default,
                position: ModalPosition = .center(.screen),
                transition: Transition = .coverVertical,
                dismissTransition: Transition? = nil,
                appearance: Appearance = Appearance(),
                behavior: Behavior = Behavior())
    {
        self.size = size
        self.position = position
        self.transition = transition
        self.dismissTransition = dismissTransition
        self.appearance = appearance
        self.behavior = behavior
    }

    var transitionForPresent: Transition {
        transition
    }

    var transitionForDismiss: Transition {
        dismissTransition ?? transition
    }

    var resolvedRoundedCorners: RoundedCorners {
        appearance.roundedCorners ?? .none
    }

    var resolvedShowSwipeIndicator: Bool {
        appearance.showSwipeIndicator ?? false
    }
}
