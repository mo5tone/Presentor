//
//  ZoomAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Scales the presented view up from (and down to) a smaller size while fading,
/// the way a system alert appears and disappears.
public final class ZoomAnimation: PresentationAnimation {
    private let initialScale: CGFloat

    public nonisolated init(initialScale: CGFloat = 0.85) {
        self.initialScale = initialScale
    }

    override public func beforeAnimation(using transitionContext: PresentorTransitionContext) {
        guard transitionContext.isPresenting else { return }
        transitionContext.animatingView?.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
        transitionContext.animatingView?.alpha = 0
    }

    override public func performAnimation(using transitionContext: PresentorTransitionContext) {
        let view = transitionContext.animatingView
        if transitionContext.isPresenting {
            view?.transform = .identity
            view?.alpha = 1
        } else {
            view?.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
            view?.alpha = 0
        }
    }

    override public func afterAnimation(using transitionContext: PresentorTransitionContext) {
        transitionContext.animatingView?.transform = .identity
        transitionContext.animatingView?.alpha = 1
    }
}
