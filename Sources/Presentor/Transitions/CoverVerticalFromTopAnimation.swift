//
//  CoverVerticalFromTopAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import CoreGraphics

public final class CoverVerticalFromTopAnimation: PresentationAnimation {
    override public func transform(containerFrame _: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = 0 - initialFrame.height
        return initialFrame
    }
}
