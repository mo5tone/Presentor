//
//  Transition.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

/// Describes the animation used to present or dismiss a view controller.
public enum Transition {
    /// Zoom in from a smaller size while fading in.
    case zoom
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
        case .zoom:
            ZoomAnimation()
        case .crossDissolve:
            CrossDissolveAnimation()
        case .coverVertical:
            CoverVerticalAnimation()
        case .coverVerticalFromTop:
            CoverVerticalFromTopAnimation()
        case .coverHorizontalFromRight:
            CoverHorizontalAnimation(fromRight: true)
        case .coverHorizontalFromLeft:
            CoverHorizontalAnimation(fromRight: false)
        case .flipHorizontal:
            FlipHorizontalAnimation()
        case let .coverFromCorner(corner):
            CoverFromCornerAnimation(corner: corner)
        case let .custom(animation):
            animation
        }
    }
}
