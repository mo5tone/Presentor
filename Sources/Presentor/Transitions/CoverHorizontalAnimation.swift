//
//  CoverHorizontalAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

public final class CoverHorizontalAnimation: PresentationAnimation {
    private let fromRight: Bool

    public init(fromRight: Bool = true) {
        self.fromRight = fromRight
        super.init()
    }

    public override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        if fromRight {
            initialFrame.origin.x = containerFrame.width + initialFrame.width
        } else {
            initialFrame.origin.x = 0 - initialFrame.width
        }
        return initialFrame
    }
}
