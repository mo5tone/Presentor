//
//  PresentorController.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import UIKit

/// Presentor's custom presentation controller. Owns sizing, positioning, the
/// background chrome, dismissal gestures, and keyboard translation.
final class PresentorController: UIPresentationController {

    // MARK: - Input

    private let presentation: Presentation
    private let contextFrameForPresentation: CGRect?

    // MARK: - State

    private var keyboardIsShowing = false

    private var conformingPresentedController: PresentorDelegate? {
        if let navigationController = presentedViewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController as? PresentorDelegate {
            return visibleViewController
        }
        return presentedViewController as? PresentorDelegate
    }

    private var shouldObserveKeyboard: Bool {
        conformingPresentedController != nil || presentation.behavior.keyboardTranslation.type != .none
    }

    private var containerFrame: CGRect {
        contextFrameForPresentation ?? containerView?.bounds ?? .zero
    }

    private var interfaceOrientation: UIInterfaceOrientation {
        containerView?.window?.windowScene?.interfaceOrientation
            ?? presentingViewController.view.window?.windowScene?.interfaceOrientation
            ?? .portrait
    }

    // MARK: - Views

    private lazy var chromeView: PassthroughView = {
        let view = PassthroughView()
        view.shouldPassthrough = false
        view.passthroughViews = []
        return view
    }()

    private lazy var backgroundView: PassthroughView = {
        let view = PassthroughView()
        view.shouldPassthrough = false
        view.passthroughViews = []
        return view
    }()

    private lazy var swipeIndicatorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 5))
        view.backgroundColor = .white
        view.alpha = 0
        view.layer.cornerRadius = 2.5
        view.isUserInteractionEnabled = false
        return view
    }()

    private var visualEffect: UIVisualEffect?

    // MARK: - Swipe state

    private var presentedViewIsBeingDismissed = false
    private var latestShouldDismiss = true
    private var initialPresentedViewCenter: CGPoint = .zero
    private var initialSwipeIndicatorCenter: CGPoint = .zero

    private lazy var shouldSwipeUp: Bool = {
        switch presentation.behavior.dismissOnSwipeDirection {
        case .up:
            return true
        case .down:
            return false
        case .automatic:
            if case .center(.top) = presentation.position { return true }
            return false
        }
    }()

    private var shouldSwipeDown: Bool { !shouldSwipeUp }

    // MARK: - Init

    init(presentedViewController: UIViewController,
         presentingViewController: UIViewController?,
         presentation: Presentation,
         contextFrameForPresentation: CGRect?) {
        self.presentation = presentation
        self.contextFrameForPresentation = contextFrameForPresentation
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)

        setupDropShadow()
        setupGestureRecognizers()

        if shouldObserveKeyboard {
            registerKeyboardObservers()
        }
    }

    deinit {
        removeKeyboardObservers()
    }

    // MARK: - Setup

    private func setupGestureRecognizers() {
        let chromeTap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
        chromeView.addGestureRecognizer(chromeTap)

        if presentation.behavior.dismissOnSwipe {
            let presentedSwipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
            presentedViewController.view.addGestureRecognizer(presentedSwipe)

            let chromeSwipe = UIPanGestureRecognizer(target: self, action: #selector(presentedViewSwipe))
            chromeView.addGestureRecognizer(chromeSwipe)
        }

        if presentation.behavior.outsideContextTap != .passthrough {
            let backgroundTap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTapped))
            backgroundView.addGestureRecognizer(backgroundTap)
        }
    }

    private func setupBackground() {
        if case .system(let style) = presentation.appearance.blur {
            visualEffect = UIBlurEffect(style: style)
        } else {
            chromeView.backgroundColor = presentation.appearance.backgroundColor
                .withAlphaComponent(CGFloat(presentation.appearance.backgroundOpacity))
        }

        if presentation.behavior.outsideContextTap == .passthrough {
            backgroundView.shouldPassthrough = true
            backgroundView.passthroughViews = presentingViewController.view.subviews
        }

        if presentation.behavior.backgroundTap == .passthrough {
            chromeView.shouldPassthrough = true
            chromeView.passthroughViews = presentingViewController.view.subviews
        }
    }

    private func setupRoundedCorners() {
        let corners = presentation.resolvedRoundedCorners
        guard let view = presentedViewController.view else { return }
        let clip: Bool

        if let userClip = corners.clipToBounds {
            clip = userClip
        } else if presentation.appearance.shadow != nil {
            clip = false
        } else {
            clip = corners.corners != .none
        }

        view.clipsToBounds = clip
        view.layer.masksToBounds = clip
        view.layer.cornerRadius = corners.corners == .none ? 0 : corners.radius
        view.layer.maskedCorners = corners.corners.maskedCorners
    }

    private func setupDropShadow() {
        guard let shadow = presentation.appearance.shadow else { return }
        let layer = presentedViewController.view.layer

        if let color = shadow.color?.cgColor { layer.shadowColor = color }
        if let opacity = shadow.opacity { layer.shadowOpacity = opacity }
        if let offset = shadow.offset { layer.shadowOffset = offset }
        if let radius = shadow.radius { layer.shadowRadius = radius }
    }

    private func setupSwipeIndicator() {
        guard presentation.resolvedShowSwipeIndicator else { return }
        swipeIndicatorView.center = centerOfSwipeIndicator(for: frameOfPresentedViewInContainerView)
    }

    private func centerOfSwipeIndicator(for presentedFrame: CGRect) -> CGPoint {
        CGPoint(x: presentedFrame.midX, y: presentedFrame.minY - 7.5)
    }

    // MARK: - Keyboard observation

    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    nonisolated private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UIPresentationController

extension PresentorController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let container = containerFrame
        let size = calculatePresentedSize(in: container.size)
        let origin = presentation.position.calculateOrigin(presentedSize: size, containerFrame: container)
        return CGRect(origin: origin, size: size)
    }

    override func containerViewWillLayoutSubviews() {
        guard !keyboardIsShowing else {
            return // Don't reset the frame while it is being translated for the keyboard.
        }
        chromeView.frame = containerFrame
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func containerViewDidLayoutSubviews() {
        setupBackground()
        setupRoundedCorners()
        setupSwipeIndicator()
    }

    override func presentationTransitionWillBegin() {
        guard let containerView else { return }

        backgroundView.frame = containerView.bounds
        chromeView.frame = containerFrame

        containerView.insertSubview(backgroundView, at: 0)
        containerView.insertSubview(chromeView, at: 1)

        if let customBackgroundView = presentation.appearance.customBackgroundView {
            chromeView.addSubview(customBackgroundView)
        }

        var blurEffectView: UIVisualEffectView?
        if visualEffect != nil {
            let view = UIVisualEffectView()
            view.frame = chromeView.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            chromeView.insertSubview(view, at: 0)
            blurEffectView = view
        } else {
            chromeView.alpha = 0.0
        }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 1.0
            swipeIndicatorView.alpha = 0.7
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            blurEffectView?.effect = self.visualEffect
            self.chromeView.alpha = 1.0
            self.swipeIndicatorView.alpha = 0.7
        })
    }

    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard presentation.resolvedShowSwipeIndicator, completed else { return }
        chromeView.addSubview(swipeIndicatorView)
    }

    override func dismissalTransitionWillBegin() {
        swipeIndicatorView.isHidden = true

        guard let coordinator = presentedViewController.transitionCoordinator else {
            chromeView.alpha = 0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            self.chromeView.alpha = 0
        })
    }
}

// MARK: - Sizing

private extension PresentorController {
    func calculatePresentedSize(in parentSize: CGSize) -> CGSize {
        let measured = measuredContentSize()
        let width = presentation.size.width.resolveWidth(parent: parentSize.width,
                                                         orientation: interfaceOrientation,
                                                         automatic: measured.width)
        let height = presentation.size.height.resolveHeight(parent: parentSize.height,
                                                            orientation: interfaceOrientation,
                                                            automatic: measured.height)
        return CGSize(width: width, height: height)
    }

    /// Always measures content; cheap enough and avoids caching invalidation bugs.
    func measuredContentSize() -> CGSize {
        #if canImport(SwiftUI)
        if let provider = presentedViewController as? PreferredSizeProviding,
           let size = provider.preferredSize(in: containerFrame.size),
           size != .zero {
            return size
        }
        #endif

        return presentedViewController.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

// MARK: - Gesture handling

extension PresentorController {
    @objc func chromeViewTapped(gesture: UIGestureRecognizer) {
        guard presentation.behavior.backgroundTap == .dismiss else { return }
        guard conformingPresentedController?.presentorShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true else {
            return
        }
        guard gesture.state == .ended else { return }
        presentingViewController.dismiss(animated: presentation.behavior.dismissAnimated)
    }

    @objc func presentedViewSwipe(gesture: UIPanGestureRecognizer) {
        guard presentation.behavior.dismissOnSwipe else { return }

        switch gesture.state {
        case .began:
            initialPresentedViewCenter = presentedViewController.view.center
            initialSwipeIndicatorCenter = swipeIndicatorView.center

            let directionDown = gesture.translation(in: presentedViewController.view).y > 0
            if (shouldSwipeDown && directionDown) || (shouldSwipeUp && !directionDown) {
                latestShouldDismiss = conformingPresentedController?.presentorShouldDismiss?(keyboardShowing: keyboardIsShowing) ?? true
            }
        case .changed:
            swipeChanged(gesture: gesture)
        case .ended, .cancelled:
            swipeEnded()
        default:
            break
        }
    }

    private func swipeChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: presentedViewController.view)

        if shouldSwipeUp, translation.y > 0 { return }
        if shouldSwipeDown, translation.y < 0 { return }

        var limit = frameOfPresentedViewInContainerView.height / 1.5
        if shouldSwipeUp { limit = -limit }

        presentedView?.center = CGPoint(x: initialPresentedViewCenter.x,
                                        y: initialPresentedViewCenter.y + translation.y)
        swipeIndicatorView.center = CGPoint(x: initialSwipeIndicatorCenter.x,
                                            y: initialSwipeIndicatorCenter.y + translation.y)

        let shouldDismiss = shouldSwipeUp ? (translation.y < limit) : (translation.y > limit)
        if shouldDismiss, latestShouldDismiss {
            presentedViewIsBeingDismissed = true
            presentingViewController.dismiss(animated: presentation.behavior.dismissAnimated)
        }
    }

    private func swipeEnded() {
        guard !presentedViewIsBeingDismissed else { return }

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 1,
                       options: [],
                       animations: {
                           self.presentedView?.center = self.initialPresentedViewCenter
                           self.swipeIndicatorView.center = self.initialSwipeIndicatorCenter
                       })
    }
}

// MARK: - Keyboard handling

extension PresentorController {
    @objc func keyboardWillShow(notification: Notification) {
        defer { keyboardIsShowing = true }

        guard notification.keyboardStartFrame != notification.keyboardEndFrame,
              let keyboardFrame = notification.keyboardEndFrame else {
            return
        }

        let presentedFrame = frameOfPresentedViewInContainerView
        let indicatorCenter = centerOfSwipeIndicator(for: presentedFrame)

        let translation = presentation.behavior.keyboardTranslation.calculate(
            keyboardFrame: keyboardFrame,
            presentedFrame: presentedFrame,
            containerFrame: containerFrame
        )

        guard translation.frame != presentedFrame else { return }

        UIView.animate(withDuration: notification.keyboardAnimationDuration ?? 0.5) {
            self.presentedView?.frame = translation.frame
            if self.presentation.resolvedShowSwipeIndicator {
                self.swipeIndicatorView.center = CGPoint(x: indicatorCenter.x,
                                                         y: indicatorCenter.y - translation.yOffset)
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        defer { keyboardIsShowing = false }

        let presentedFrame = frameOfPresentedViewInContainerView
        let indicatorCenter = centerOfSwipeIndicator(for: presentedFrame)

        guard presentedFrame != presentedView?.frame else { return }

        UIView.animate(withDuration: notification.keyboardAnimationDuration ?? 0.5) {
            self.presentedView?.frame = presentedFrame
            if self.presentation.resolvedShowSwipeIndicator {
                self.swipeIndicatorView.center = indicatorCenter
            }
        }
    }
}

private extension Corners {
    var maskedCorners: CACornerMask {
        switch self {
        case .none:
            return []
        case .all:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .top:
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom:
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .left:
            return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        case .right:
            return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}
