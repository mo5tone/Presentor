//
//  Presentation+Presets.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

import CoreGraphics

public extension Presentation {
    /// A small 270x180 alert, centered, with rounded corners, zooming in and out.
    static let alert = Presentation(
        size: ModalSize(width: .fixed(270), height: .fixed(180)),
        position: .center(.screen),
        transition: .zoom,
        appearance: Appearance(roundedCorners: .all)
    )

    /// A default-sized popup, centered, with rounded corners, zooming in and out.
    static let popup = Presentation(
        size: .default,
        position: .center(.screen),
        transition: .zoom,
        appearance: Appearance(roundedCorners: .all)
    )

    /// The top half of the screen, sliding down from the top.
    static let topHalf = Presentation(
        size: ModalSize(width: .full, height: .half),
        position: .center(.top),
        transition: .coverVerticalFromTop,
        appearance: Appearance(roundedCorners: RoundedCorners.none)
    )

    /// The bottom half of the screen, sliding up from the bottom.
    static let bottomHalf = Presentation(
        size: ModalSize(width: .full, height: .half),
        position: .center(.bottom),
        transition: .coverVertical,
        appearance: Appearance(roundedCorners: RoundedCorners.none)
    )

    /// A full-screen presentation.
    static let fullScreen = Presentation(
        size: ModalSize(width: .full, height: .full),
        position: .center(.screen),
        transition: .coverVertical,
        appearance: Appearance(roundedCorners: RoundedCorners.none)
    )

    /// A bottom card with rounded top corners and a swipe indicator.
    static let bottomCard = Presentation(
        size: ModalSize(width: .full, height: .fixed(350)),
        position: .edge(.bottom(padding: 0)),
        transition: .coverVertical,
        appearance: Appearance(roundedCorners: RoundedCorners(.top, radius: 15), showSwipeIndicator: true),
        behavior: Behavior(dismissOnSwipe: true)
    )

    /// A presentation sized to fit the content using Auto Layout.
    ///
    /// Ensure the presented view has unambiguous constraints in both axes.
    static func dynamic(position: ModalPosition = .center(.screen)) -> Presentation {
        Presentation(
            size: ModalSize(width: .automatic, height: .automatic),
            position: position,
            transition: .coverVertical
        )
    }
}
