//
//  CrossDissolveAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

public final class CrossDissolveAnimation: PresentationAnimation {
    override public func beforeAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
    }

    override public func performAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
    }

    override public func afterAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = 1.0
    }
}
