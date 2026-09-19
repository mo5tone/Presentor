//
//  Behavior.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Interaction configuration for a presentation.
public struct Behavior {
    /// What happens when the background chrome is tapped.
    public var backgroundTap: BackgroundTapAction
    /// What happens when the area outside the presentation context is tapped.
    public var outsideContextTap: BackgroundTapAction
    /// Whether the presented view can be dismissed by swiping it.
    public var dismissOnSwipe: Bool
    /// The direction used to dismiss by swipe.
    public var dismissOnSwipeDirection: DismissSwipeDirection
    /// Whether tap- and swipe-to-dismiss are animated.
    public var dismissAnimated: Bool
    /// How the presented view responds to the keyboard.
    public var keyboardTranslation: KeyboardTranslation
    /// The view controller whose frame defines the presentation context.
    /// Set this right before presenting so Auto Layout has settled.
    public weak var context: UIViewController?

    public init(backgroundTap: BackgroundTapAction = .dismiss,
                outsideContextTap: BackgroundTapAction = .passthrough,
                dismissOnSwipe: Bool = false,
                dismissOnSwipeDirection: DismissSwipeDirection = .automatic,
                dismissAnimated: Bool = true,
                keyboardTranslation: KeyboardTranslation = .none,
                context: UIViewController? = nil) {
        self.backgroundTap = backgroundTap
        self.outsideContextTap = outsideContextTap
        self.dismissOnSwipe = dismissOnSwipe
        self.dismissOnSwipeDirection = dismissOnSwipeDirection
        self.dismissAnimated = dismissAnimated
        self.keyboardTranslation = keyboardTranslation
        self.context = context
    }
}
