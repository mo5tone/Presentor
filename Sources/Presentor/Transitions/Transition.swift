//
//  Transition.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

/// Describes the animation used to present or dismiss a view controller.
public enum Transition {
    /// Cross-fade.
    case crossDissolve
    /// Slide in vertically from the bottom.
    case coverVertical
    /// Slide in vertically from the top.
    case coverVerticalFromTop
    /// Slide in horizontally from the right.
    case coverHorizontalFromRight
    /// Slide in horizontally from the left.
    case coverHorizontalFromLeft
    /// Flip the new view horizontally.
    case flipHorizontal
    /// Slide in from a given corner.
    case coverFromCorner(Corner)
    /// A user-provided animation.
    case custom(PresentationAnimation)

    /// Returns the animation object responsible for this transition.
    public func animation() -> PresentationAnimation {
        switch self {
        case .crossDissolve:
            return CrossDissolveAnimation()
        case .coverVertical:
            return CoverVerticalAnimation()
        case .coverVerticalFromTop:
            return CoverVerticalFromTopAnimation()
        case .coverHorizontalFromRight:
            return CoverHorizontalAnimation(fromRight: true)
        case .coverHorizontalFromLeft:
            return CoverHorizontalAnimation(fromRight: false)
        case .flipHorizontal:
            return FlipHorizontalAnimation()
        case .coverFromCorner(let corner):
            return CoverFromCornerAnimation(corner: corner)
        case .custom(let animation):
            return animation
        }
    }
}
