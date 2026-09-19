//
//  PassthroughView.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// A view that can forward hit-testing to a set of other views, allowing touches
/// to "pass through" the presentation chrome.
final class PassthroughView: UIView {
    var shouldPassthrough = true
    var passthroughViews: [UIView] = []

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)

        if view == self, shouldPassthrough {
            for passthroughView in passthroughViews {
                view = passthroughView.hitTest(convert(point, to: passthroughView), with: event)
                if view != nil {
                    break
                }
            }
        }

        return view
    }
}
