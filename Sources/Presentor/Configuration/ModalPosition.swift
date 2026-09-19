//
//  ModalPosition.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import CoreGraphics

/// Describes where a presented view controller is placed inside its container.
public enum ModalPosition: Equatable, Sendable {
    /// Center the presented view on a `Center` anchor.
    case center(Center)
    /// Place the presented view at a fixed origin.
    case origin(CGPoint)
    /// Pin the presented view to a screen edge, inset by a padding.
    case edge(Edge)

    /// Describes the center point used by the `.center` case.
    public enum Center: Equatable, Sendable {
        /// Center of the container.
        case screen
        /// Center of the top half of the container.
        case top
        /// Center of the bottom half of the container.
        case bottom
        /// A fixed center point.
        case custom(CGPoint)
    }

    /// Describes a container edge the presented view is pinned to.
    public enum Edge: Equatable, Sendable {
        case topLeft(padding: CGFloat)
        case top(padding: CGFloat)
        case topRight(padding: CGFloat)
        case bottomLeft(padding: CGFloat)
        case bottom(padding: CGFloat)
        case bottomRight(padding: CGFloat)
    }
}

extension ModalPosition.Edge {
    var padding: CGFloat {
        switch self {
        case .topLeft(let padding),
             .top(let padding),
             .topRight(let padding),
             .bottomLeft(let padding),
             .bottom(let padding),
             .bottomRight(let padding):
            return padding
        }
    }
}

extension ModalPosition {
    /// Calculates the origin of the presented view's frame.
    ///
    /// - Parameters:
    ///   - presentedSize: The resolved size of the presented view.
    ///   - containerFrame: The frame of the container the view is presented in.
    func calculateOrigin(presentedSize: CGSize, containerFrame: CGRect) -> CGPoint {
        switch self {
        case .origin(let origin):
            return origin
        case .center(let center):
            return center.calculateOrigin(presentedSize: presentedSize, containerFrame: containerFrame)
        case .edge(let edge):
            return edge.calculateOrigin(presentedSize: presentedSize, containerFrame: containerFrame)
        }
    }
}

extension ModalPosition.Center {
    func calculateOrigin(presentedSize: CGSize, containerFrame: CGRect) -> CGPoint {
        let halfWidth = presentedSize.width / 2
        let halfHeight = presentedSize.height / 2
        let halfContainerWidth = containerFrame.width / 2
        let halfContainerHeight = containerFrame.height / 2

        switch self {
        case .screen:
            return CGPoint(x: containerFrame.minX + halfContainerWidth - halfWidth,
                           y: containerFrame.minY + halfContainerHeight - halfHeight)
        case .top:
            return CGPoint(x: containerFrame.minX + halfContainerWidth - halfWidth,
                           y: containerFrame.minY + (containerFrame.height * (1 / 4) - 1) - halfHeight)
        case .bottom:
            return CGPoint(x: containerFrame.minX + halfContainerWidth - halfWidth,
                           y: containerFrame.minY + (containerFrame.height * (3 / 4)) - halfHeight)
        case .custom(let point):
            return point
        }
    }
}

extension ModalPosition.Edge {
    func calculateOrigin(presentedSize: CGSize, containerFrame: CGRect) -> CGPoint {
        switch self {
        case .topLeft:
            return CGPoint(x: containerFrame.minX + padding,
                           y: containerFrame.minY + padding)
        case .top:
            return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedSize.width / 2),
                           y: containerFrame.minY + padding)
        case .topRight:
            return CGPoint(x: containerFrame.maxX - presentedSize.width - padding,
                           y: containerFrame.minY + padding)
        case .bottomLeft:
            return CGPoint(x: containerFrame.minX + padding,
                           y: containerFrame.maxY - presentedSize.height - padding)
        case .bottom:
            return CGPoint(x: containerFrame.minX + (containerFrame.width / 2) - (presentedSize.width / 2),
                           y: containerFrame.maxY - presentedSize.height - padding)
        case .bottomRight:
            return CGPoint(x: containerFrame.maxX - presentedSize.width - padding,
                           y: containerFrame.maxY - presentedSize.height - padding)
        }
    }
}
