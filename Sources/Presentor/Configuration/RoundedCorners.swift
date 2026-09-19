//
//  RoundedCorners.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import CoreGraphics

/// The corners of a view that should be rounded.
public enum Corners: Equatable, Sendable {
    case none
    case all
    case top
    case bottom
    case left
    case right
}

/// Describes the corner radius applied to a presented view.
public struct RoundedCorners: Equatable, Sendable {
    public var corners: Corners
    public var radius: CGFloat
    /// Whether the view should clip to bounds. When `nil`, Presentor decides
    /// based on whether a drop shadow is configured.
    public var clipToBounds: Bool?

    public init(_ corners: Corners, radius: CGFloat = 4.0, clipToBounds: Bool? = nil) {
        self.corners = corners
        self.radius = radius
        self.clipToBounds = clipToBounds
    }

    public static let none = RoundedCorners(.none)
    public static let all = RoundedCorners(.all)
    public static let top = RoundedCorners(.top)
    public static let bottom = RoundedCorners(.bottom)
    public static let left = RoundedCorners(.left)
    public static let right = RoundedCorners(.right)
}
