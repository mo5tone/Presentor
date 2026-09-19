//
//  PresentationAnimation.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// A simplified wrapper around `UIViewControllerContextTransitioning`, passed to
/// `PresentationAnimation` hooks.
public struct PresentorTransitionContext {
    public let containerView: UIView
    public let initialFrame: CGRect
    public let finalFrame: CGRect
    public let isPresenting: Bool
    public let fromViewController: UIViewController?
    public let toViewController: UIViewController?
    public let fromView: UIView?
    public let toView: UIView?
    public let animatingViewController: UIViewController?
    public let animatingView: UIView?
}

/// The timing used for a transition's `UIView` animation.
public enum AnimationTiming: Equatable {
    case normal(duration: TimeInterval)
    case spring(duration: TimeInterval, delay: TimeInterval, damping: CGFloat, velocity: CGFloat)

    var duration: TimeInterval {
        switch self {
        case .normal(let duration):
            return duration
        case .spring(let duration, _, _, _):
            return duration
        }
    }
}

/// The base class for transition animations.
///
/// Override `transform(containerFrame:finalFrame:)` for simple movement
/// animations, or `beforeAnimation`/`performAnimation` (and optionally
/// `afterAnimation`) for fully custom ones.
open class PresentationAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    public var timing: AnimationTiming

    public init(timing: AnimationTiming = .normal(duration: 0.4)) {
        self.timing = timing
    }

    /// Returns the initial frame for a simple movement animation.
    open func transform(containerFrame: CGRect, finalFrame: CGRect) -> CGRect {
        var initialFrame = finalFrame
        initialFrame.origin.y = containerFrame.height + initialFrame.height
        return initialFrame
    }

    /// Performed before the animation begins.
    open func beforeAnimation(using transitionContext: PresentorTransitionContext) {
        let finalFrame = transitionContext.finalFrame
        let initialFrame = transform(containerFrame: transitionContext.containerView.frame, finalFrame: finalFrame)
        transitionContext.animatingView?.frame = transitionContext.isPresenting ? initialFrame : finalFrame
    }

    /// Performed as the animation body.
    open func performAnimation(using transitionContext: PresentorTransitionContext) {
        let finalFrame = transitionContext.finalFrame
        let initialFrame = transform(containerFrame: transitionContext.containerView.frame, finalFrame: finalFrame)
        transitionContext.animatingView?.frame = transitionContext.isPresenting ? finalFrame : initialFrame
    }

    /// Performed after the animation completes.
    open func afterAnimation(using transitionContext: PresentorTransitionContext) {}

    // MARK: UIViewControllerAnimatedTransitioning

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        timing.duration
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        let isPresenting = (toViewController?.presentingViewController == fromViewController)
        let animatingViewController = isPresenting ? toViewController : fromViewController
        let animatingView = isPresenting ? toView : fromView

        guard let animatingViewController else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            return
        }

        let context = PresentorTransitionContext(
            containerView: containerView,
            initialFrame: transitionContext.initialFrame(for: animatingViewController),
            finalFrame: transitionContext.finalFrame(for: animatingViewController),
            isPresenting: isPresenting,
            fromViewController: fromViewController,
            toViewController: toViewController,
            fromView: fromView,
            toView: toView,
            animatingViewController: animatingViewController,
            animatingView: animatingView
        )

        if isPresenting, let toView {
            containerView.addSubview(toView)
        }

        switch timing {
        case .normal(let duration):
            animate(context: context, transitionContext: transitionContext, duration: duration)
        case .spring(let duration, let delay, let damping, let velocity):
            animateWithSpring(context: context,
                              transitionContext: transitionContext,
                              duration: duration,
                              delay: delay,
                              damping: damping,
                              velocity: velocity)
        }
    }

    private func animate(context: PresentorTransitionContext,
                         transitionContext: UIViewControllerContextTransitioning,
                         duration: TimeInterval) {
        beforeAnimation(using: context)
        UIView.animate(withDuration: duration, animations: {
            self.performAnimation(using: context)
        }, completion: { _ in
            self.afterAnimation(using: context)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

    private func animateWithSpring(context: PresentorTransitionContext,
                                   transitionContext: UIViewControllerContextTransitioning,
                                   duration: TimeInterval,
                                   delay: TimeInterval,
                                   damping: CGFloat,
                                   velocity: CGFloat) {
        beforeAnimation(using: context)
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity,
                       options: [],
                       animations: {
                           self.performAnimation(using: context)
                       }, completion: { _ in
                           self.afterAnimation(using: context)
                           transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                       })
    }
}
