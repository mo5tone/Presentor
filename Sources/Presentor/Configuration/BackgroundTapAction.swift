//
//  BackgroundTapAction.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

/// The action performed when the background chrome of a presentation is tapped.
public enum BackgroundTapAction: Equatable, Sendable {
    /// Nothing happens.
    case none
    /// The presented view controller is dismissed.
    case dismiss
    /// The touch passes through to the presenting view controller.
    case passthrough
}

/// The direction in which the user can swipe a presented view to dismiss it.
public enum DismissSwipeDirection: Equatable, Sendable {
    /// Presentor chooses the direction based on the presentation position.
    case automatic
    /// Dismiss by swiping down.
    case down
    /// Dismiss by swiping up.
    case up
}
