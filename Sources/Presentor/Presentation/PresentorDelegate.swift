//
//  PresentorDelegate.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

/// A protocol a presented view controller (or its visible child) can conform to
/// in order to observe and influence dismissal.
@objc public protocol PresentorDelegate {
    /// Asks the delegate whether the presented controller should be dismissed.
    ///
    /// Use this to validate requirements or finish work before dismissal.
    ///
    /// - Parameter keyboardShowing: Whether the keyboard is currently shown.
    /// - Returns: `false` to prevent dismissal, otherwise `true`.
    @objc optional func presentorShouldDismiss(keyboardShowing: Bool) -> Bool
}
