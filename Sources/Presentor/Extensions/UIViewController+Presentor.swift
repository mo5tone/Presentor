//
//  UIViewController+Presentor.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

@MainActor
private enum PresentorAssociationKeys {
    static var coordinator: UInt8 = 0
}

public extension UIViewController {
    /// Present a view controller using a `Presentation` value.
    ///
    /// The presentation's transitioning delegate is retained for the lifetime of
    /// the presented view controller, so no external reference is required.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present.
    ///   - presentation: The presentation configuration.
    ///   - animated: Whether to animate the presentation.
    ///   - completion: Called when the presentation finishes.
    func present(_ viewController: UIViewController,
                 using presentation: Presentation,
                 animated: Bool = true,
                 completion: (() -> Void)? = nil) {
        let coordinator = PresentationCoordinator(presentation: presentation)
        objc_setAssociatedObject(viewController,
                                 &PresentorAssociationKeys.coordinator,
                                 coordinator,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        viewController.transitioningDelegate = coordinator
        viewController.modalPresentationStyle = .custom
        present(viewController, animated: animated, completion: completion)
    }

    /// Present a view controller using a `Presentation` value, returning when the
    /// presentation finishes.
    @discardableResult
    func present(_ viewController: UIViewController,
                 using presentation: Presentation,
                 animated: Bool = true) async -> Bool {
        await withCheckedContinuation { continuation in
            present(viewController, using: presentation, animated: animated) {
                continuation.resume(returning: true)
            }
        }
    }

    /// Dismiss the currently presented view controller, returning when it finishes.
    func dismissPresented(animated: Bool = true) async {
        await withCheckedContinuation { continuation in
            dismiss(animated: animated) {
                continuation.resume()
            }
        }
    }
}
