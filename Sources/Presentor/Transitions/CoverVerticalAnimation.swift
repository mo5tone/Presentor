//
//  CoverVerticalAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import CoreGraphics

public final class CoverVerticalAnimation: PresentationAnimation {
    override public func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.height + initialFrame.height
        return initialFrame
    }
}
