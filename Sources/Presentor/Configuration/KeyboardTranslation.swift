//
//  KeyboardTranslation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Describes how a presented view controller responds to the keyboard.
public struct KeyboardTranslation: Equatable, Sendable {
    public enum TranslationType: Equatable, Sendable {
        /// The presented view does not move.
        case none
        /// The presented view moves up just enough to clear the keyboard.
        case moveUp
        /// The presented view moves up and shrinks to fit above the keyboard.
        case compress
        /// The presented view moves up until it is pinned near the top of the container.
        case stickToTop
    }

    public var type: TranslationType
    /// Extra padding to keep between the presented view and the keyboard.
    /// When `nil`, Presentor uses a 20pt buffer (0 when the view is pinned to the bottom).
    public var padding: CGFloat?

    public init(_ type: TranslationType, padding: CGFloat? = nil) {
        self.type = type
        self.padding = padding
    }

    public static let none = KeyboardTranslation(.none)
    public static let moveUp = KeyboardTranslation(.moveUp)
    public static let compress = KeyboardTranslation(.compress)
    public static let stickToTop = KeyboardTranslation(.stickToTop)

    /// Calculates the frame to translate the presented view to, plus the vertical offset applied.
    ///
    /// - Parameters:
    ///   - keyboardFrame: The keyboard end frame, in window coordinates.
    ///   - presentedFrame: The current frame of the presented view.
    ///   - containerFrame: The frame of the presentation container.
    /// - Returns: The translated frame and the y offset that was applied.
    func calculate(keyboardFrame: CGRect,
                   presentedFrame: CGRect,
                   containerFrame: CGRect) -> (frame: CGRect, yOffset: CGFloat)
    {
        let keyboardTop = containerFrame.maxY - keyboardFrame.height
        let isFullScreen = (presentedFrame.maxY == containerFrame.maxY)
        let buffer: CGFloat = if isFullScreen {
            0
        } else if let padding {
            padding
        } else {
            20
        }

        let presentedViewBottom = presentedFrame.maxY + buffer
        let offset = presentedViewBottom - keyboardTop

        switch type {
        case .none:
            return (presentedFrame, 0)
        case .moveUp:
            guard offset > 0 else { return (presentedFrame, 0) }
            let frame = presentedFrame.offsetBy(dx: 0, dy: -offset)
            return (frame, offset)
        case .compress:
            guard offset > 0 else { return (presentedFrame, 0) }
            let y = max(presentedFrame.origin.y - offset, 20.0)
            let newHeight = y != 20.0 ? presentedFrame.height : keyboardTop - 40.0
            let frame = CGRect(x: presentedFrame.origin.x, y: y, width: presentedFrame.width, height: newHeight)
            return (frame, 0)
        case .stickToTop:
            guard offset > 0 else { return (presentedFrame, 0) }
            let y = max(presentedFrame.origin.y - offset, 20.0)
            let frame = CGRect(x: presentedFrame.origin.x, y: y, width: presentedFrame.width, height: presentedFrame.height)
            return (frame, offset)
        }
    }
}

extension Notification {
    var keyboardStartFrame: CGRect? {
        (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }

    var keyboardEndFrame: CGRect? {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }

    var keyboardAnimationDuration: TimeInterval? {
        (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
    }
}
