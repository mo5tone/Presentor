//
//  CoverVerticalFromTopAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

public final class CoverVerticalFromTopAnimation: PresentationAnimation {
    public override func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = 0 - initialFrame.height
        return initialFrame
    }
}
