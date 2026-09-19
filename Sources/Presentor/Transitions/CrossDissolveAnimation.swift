//
//  CrossDissolveAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import Foundation

public final class CrossDissolveAnimation: PresentationAnimation {
    public override func beforeAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
    }

    public override func performAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
    }

    public override func afterAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.alpha = 1.0
    }
}
