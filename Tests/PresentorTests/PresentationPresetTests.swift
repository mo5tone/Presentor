@testable import Presentor
import Testing

struct PresentationPresetTests {
    @Test func alertPreset() {
        #expect(Presentation.alert.size.width == .fixed(270))
        #expect(Presentation.alert.size.height == .fixed(180))
        #expect(Presentation.alert.position == .center(.screen))
        #expect(Presentation.alert.resolvedRoundedCorners == RoundedCorners.all)
        #expect(Presentation.alert.transitionForPresent.animation() is ZoomAnimation)
        #expect(Presentation.alert.transitionForDismiss.animation() is ZoomAnimation)
    }

    @Test func popupPresetZooms() {
        #expect(Presentation.popup.transitionForPresent.animation() is ZoomAnimation)
    }

    @Test func bottomCardPreset() {
        #expect(Presentation.bottomCard.position == .edge(.bottom(padding: 0)))
        #expect(Presentation.bottomCard.appearance.roundedCorners == RoundedCorners(.top, radius: 15))
        #expect(Presentation.bottomCard.resolvedShowSwipeIndicator)
        #expect(Presentation.bottomCard.behavior.dismissOnSwipe)
    }

    @Test func dynamicPresetUsesAutomaticDimensions() {
        let presentation = Presentation.dynamic()
        #expect(presentation.size.width == .automatic)
        #expect(presentation.size.height == .automatic)
    }

    @Test func dismissTransitionFallsBackToPresentTransition() {
        var presentation = Presentation.popup
        presentation.transition = .crossDissolve
        presentation.dismissTransition = nil
        #expect(presentation.transitionForDismiss.animation() is CrossDissolveAnimation)
    }
}
