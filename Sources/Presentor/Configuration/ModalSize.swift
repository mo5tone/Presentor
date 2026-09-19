//
//  ModalSize.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Describes a single dimension (width or height) of a presented view controller.
///
/// The value is intentionally screen-independent: the presentation controller
/// resolves it against the container size and current interface orientation.
public enum ModalDimension: Equatable, Sendable {
    /// Presentor's default sizing (side margins for width, a percentage for height).
    case `default`
    /// Half of the container.
    case half
    /// The full container.
    case full
    /// A fixed point value.
    case fixed(Double)
    /// A percentage of the container, in the `0...1` range.
    case percent(Double)
    /// The full container minus the given padding on both sides.
    case padding(Double)
    /// A fixed point value that differs per orientation.
    case orientation(portrait: Double, landscape: Double)
    /// Size to fit the presented view's Auto Layout content.
    case automatic
}

/// The width and height of a presented view controller.
public struct ModalSize: Equatable, Sendable {
    public var width: ModalDimension
    public var height: ModalDimension

    public init(width: ModalDimension, height: ModalDimension) {
        self.width = width
        self.height = height
    }

    /// Presentor's default size: side margins for width and a percentage for height.
    public static let `default` = ModalSize(width: .default, height: .default)
}

enum PresentorConstants {
    static let defaultSideMargin: Double = 30.0
    static let defaultHeightPercentage: Double = 0.66
}

extension ModalDimension {
    /// Resolves this dimension into a concrete width.
    ///
    /// - Parameters:
    ///   - parent: The width of the containing view.
    ///   - orientation: The current interface orientation, used by `.orientation`.
    ///   - automatic: The measured content width, used by `.automatic`.
    func resolveWidth(parent: CGFloat,
                      orientation: UIInterfaceOrientation,
                      automatic: CGFloat = 0) -> CGFloat
    {
        switch self {
        case .default:
            floor(parent - CGFloat(PresentorConstants.defaultSideMargin * 2))
        case .half:
            floor(parent / 2)
        case .full:
            parent
        case let .fixed(value):
            CGFloat(value)
        case let .percent(percentage):
            floor(parent * CGFloat(percentage))
        case let .padding(padding):
            floor(parent - CGFloat(padding) * 2)
        case let .orientation(portrait, landscape):
            min(parent, CGFloat(orientation.appearsLandscape ? landscape : portrait))
        case .automatic:
            automatic
        }
    }

    /// Resolves this dimension into a concrete height.
    func resolveHeight(parent: CGFloat,
                       orientation: UIInterfaceOrientation,
                       automatic: CGFloat = 0) -> CGFloat
    {
        switch self {
        case .default:
            floor(parent * CGFloat(PresentorConstants.defaultHeightPercentage))
        case .half:
            floor(parent / 2)
        case .full:
            parent
        case let .fixed(value):
            CGFloat(value)
        case let .percent(percentage):
            floor(parent * CGFloat(percentage))
        case let .padding(padding):
            floor(parent - CGFloat(padding) * 2)
        case let .orientation(portrait, landscape):
            min(parent, CGFloat(orientation.appearsLandscape ? landscape : portrait))
        case .automatic:
            automatic
        }
    }
}

extension UIInterfaceOrientation {
    var appearsLandscape: Bool {
        self == .landscapeLeft || self == .landscapeRight
    }
}
