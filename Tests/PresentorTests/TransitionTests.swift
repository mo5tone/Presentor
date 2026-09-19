import Foundation
import Testing
@testable import Presentor

@MainActor
@Suite struct TransitionTests {
    private let container = CGRect(x: 0, y: 0, width: 400, height: 800)
    private let finalFrame = CGRect(x: 100, y: 300, width: 200, height: 200)

    @Test func coverVerticalStartsBelowContainer() {
        let frame = CoverVerticalAnimation().transform(containerFrame: container, finalFrame: finalFrame)
        #expect(frame == CGRect(x: 100, y: 1000, width: 200, height: 200))
    }

    @Test func coverVerticalFromTopStartsAboveContainer() {
        let frame = CoverVerticalFromTopAnimation().transform(containerFrame: container, finalFrame: finalFrame)
        #expect(frame == CGRect(x: 100, y: -200, width: 200, height: 200))
    }

    @Test func coverHorizontal() {
        let right = CoverHorizontalAnimation(fromRight: true).transform(containerFrame: container, finalFrame: finalFrame)
        #expect(right.origin.x == 600)

        let left = CoverHorizontalAnimation(fromRight: false).transform(containerFrame: container, finalFrame: finalFrame)
        #expect(left.origin.x == -200)
    }

    @Test func coverFromCorner() {
        let topLeft = CoverFromCornerAnimation(corner: .topLeft).transform(containerFrame: container, finalFrame: finalFrame)
        #expect(topLeft.origin == CGPoint(x: -200, y: -200))

        let bottomRight = CoverFromCornerAnimation(corner: .bottomRight).transform(containerFrame: container, finalFrame: finalFrame)
        #expect(bottomRight.origin == CGPoint(x: 600, y: 1000))
    }

    @Test func transitionMapsToAnimationType() {
        #expect(Transition.zoom.animation() is ZoomAnimation)
        #expect(Transition.crossDissolve.animation() is CrossDissolveAnimation)
        #expect(Transition.flipHorizontal.animation() is FlipHorizontalAnimation)
        #expect(Transition.coverFromCorner(.topLeft).animation() is CoverFromCornerAnimation)
    }

    @Test func customTransitionReturnsProvidedAnimation() {
        let animation = CrossDissolveAnimation()
        #expect(Transition.custom(animation).animation() === animation)
    }
}
