//
//  Appearance.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Visual configuration for a presentation.
public struct Appearance {
    public enum Blur: Equatable {
        case none
        case system(UIBlurEffect.Style)
    }

    /// Color of the background chrome. Ignored when `blur` is not `.none`.
    public var backgroundColor: UIColor
    /// Opacity of the background chrome. Ignored when `blur` is not `.none`.
    public var backgroundOpacity: Float
    /// Blur applied to the background chrome.
    public var blur: Blur
    /// A custom view added on top of the background chrome.
    public var customBackgroundView: UIView?
    /// Rounded corners for the presented view. When `nil`, the presentation's preset default is used.
    public var roundedCorners: RoundedCorners?
    /// Drop shadow for the presented view.
    public var shadow: PresentorShadow?
    /// Whether to show the swipe indicator nub. When `nil`, the presentation's preset default is used.
    public var showSwipeIndicator: Bool?

    public init(backgroundColor: UIColor = .black,
                backgroundOpacity: Float = 0.7,
                blur: Blur = .none,
                customBackgroundView: UIView? = nil,
                roundedCorners: RoundedCorners? = nil,
                shadow: PresentorShadow? = nil,
                showSwipeIndicator: Bool? = nil) {
        self.backgroundColor = backgroundColor
        self.backgroundOpacity = backgroundOpacity
        self.blur = blur
        self.customBackgroundView = customBackgroundView
        self.roundedCorners = roundedCorners
        self.shadow = shadow
        self.showSwipeIndicator = showSwipeIndicator
    }
}
