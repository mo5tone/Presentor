//
//  PresentorShadow.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Describes the drop shadow applied to a presented view.
public struct PresentorShadow: Equatable {
    public var color: UIColor?
    public var opacity: Float?
    public var offset: CGSize?
    public var radius: CGFloat?

    public init(color: UIColor? = nil,
                opacity: Float? = nil,
                offset: CGSize? = nil,
                radius: CGFloat? = nil)
    {
        self.color = color
        self.opacity = opacity
        self.offset = offset
        self.radius = radius
    }
}
