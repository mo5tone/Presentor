//
//  PreferredSizeProviding.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

#if canImport(SwiftUI)
import SwiftUI

/// A view controller that can report the size its content wants to be.
///
/// Used by the presentation controller to resolve `.automatic` dimensions
/// (`Presentation.dynamic()`). UIKit view controllers are measured with Auto
/// Layout; SwiftUI content has no Auto Layout intrinsic size, so hosting
/// controllers provide their own measurement.
@MainActor
protocol PreferredSizeProviding: AnyObject {
    func preferredSize(in containerSize: CGSize) -> CGSize?
}

extension UIHostingController: PreferredSizeProviding {
    func preferredSize(in containerSize: CGSize) -> CGSize? {
        loadViewIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()

        if #available(iOS 16.0, *) {
            return sizeThatFits(in: containerSize)
        }

        // Best effort on iOS 15, where UIHostingController has no sizeThatFits.
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size == .zero ? nil : size
    }
}
#endif
