//
//  FlipHorizontalAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//
//  Inspired by https://stackoverflow.com/questions/12565204
//

import UIKit

public final class FlipHorizontalAnimation: PresentationAnimation {
    override public func performAnimation(using transitionContext: PresentorTransitionContext) {
        // Keep the flipping views above the background chrome.
        transitionContext.toView?.layer.zPosition = 999
        transitionContext.fromView?.layer.zPosition = 999

        var fromRotation = CATransform3DIdentity
        fromRotation.m34 = -0.003
        fromRotation = CATransform3DRotate(fromRotation, .pi / 2.0, 0.0, -1.0, 0.0)

        var toRotation = CATransform3DIdentity
        toRotation.m34 = -0.003
        toRotation = CATransform3DRotate(toRotation, .pi / 2.0, 0.0, 1.0, 0.0)

        transitionContext.toView?.layer.transform = toRotation

        UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear, animations: {
            transitionContext.fromView?.layer.transform = fromRotation
        }, completion: { _ in
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveLinear) {
                transitionContext.toView?.layer.transform = CATransform3DMakeRotation(.pi / 2.0, 0.0, 0.0, 0.0)
            }
        })
    }
}
