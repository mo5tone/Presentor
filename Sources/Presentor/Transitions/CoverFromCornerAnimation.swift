//
//  CoverFromCornerAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

/// A corner used by `Transition.coverFromCorner(_:)`.
public enum Corner: Equatable, Sendable {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight

    var isTop: Bool {
        switch self {
        case .topLeft, .topRight: return true
        default: return false
        }
    }

    var isLeft: Bool {
        switch self {
        case .topLeft, .bottomLeft: return true
        default: return false
        }
    }
}

public final class CoverFromCornerAnimation: PresentationAnimation {
    private let corner: Corner

    public init(corner: Corner) {
        self.corner = corner
        super.init()
    }

    public override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame

        initialFrame.origin.y = corner.isTop
            ? 0 - initialFrame.height
            : containerFrame.height + initialFrame.height

        initialFrame.origin.x = corner.isLeft
            ? 0 - initialFrame.width
            : containerFrame.width + initialFrame.width

        return initialFrame
    }
}
