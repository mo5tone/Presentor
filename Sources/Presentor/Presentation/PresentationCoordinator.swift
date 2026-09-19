//
//  PresentationCoordinator.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Retains the configuration for a single presentation and acts as its
/// transitioning delegate.
///
/// A coordinator is attached to the presented view controller via an associated
/// object for the lifetime of the presentation, so callers do not need to keep a
/// reference alive themselves.
final class PresentationCoordinator: NSObject, UIViewControllerTransitioningDelegate {
    private let presentation: Presentation
    private let contextFrame: CGRect?

    init(presentation: Presentation) {
        self.presentation = presentation

        if let context = presentation.behavior.context,
           let view = context.view {
            let origin = view.convert(view.frame.origin, to: nil)
            self.contextFrame = CGRect(x: origin.x, y: origin.y, width: view.bounds.width, height: view.bounds.height)
        } else {
            self.contextFrame = nil
        }

        super.init()
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        PresentorController(presentedViewController: presented,
                            presentingViewController: presenting,
                            presentation: presentation,
                            contextFrameForPresentation: contextFrame)
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentation.transitionForPresent.animation()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentation.transitionForDismiss.animation()
    }
}
