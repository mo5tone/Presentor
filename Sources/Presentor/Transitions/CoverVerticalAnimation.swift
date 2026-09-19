//
//  CoverVerticalAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

public final class CoverVerticalAnimation: PresentationAnimation {
    public override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.height + initialFrame.height
        return initialFrame
    }
}
