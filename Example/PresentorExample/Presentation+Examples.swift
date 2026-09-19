import Presentor

extension Presentation {
    /// A floating card pinned to the bottom of the screen:
    /// 400pt tall, 32pt horizontal padding, 48pt from the bottom, 32pt corners.
    static var floatingCard: Presentation {
        var presentation = Presentation()
        presentation.size = ModalSize(width: .padding(32), height: .fixed(400))
        presentation.position = .edge(.bottom(padding: 48))
        presentation.transition = .coverVertical
        presentation.appearance.roundedCorners = RoundedCorners(.all, radius: 32)
        presentation.behavior.dismissOnSwipe = true
        presentation.behavior.dismissOnSwipeDirection = .down
        return presentation
    }
}
