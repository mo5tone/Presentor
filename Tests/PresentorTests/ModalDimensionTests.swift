import Foundation
import Testing
@testable import Presentor

@Suite struct ModalDimensionTests {
    @Test func defaultUsesMarginsForWidthAndPercentageForHeight() {
        // 400 - 30*2 = 340
        #expect(ModalDimension.default.resolveWidth(parent: 400, orientation: .portrait) == 340)
        // 800 * 0.66 = 528
        #expect(ModalDimension.default.resolveHeight(parent: 800, orientation: .portrait) == 528)
    }

    @Test func halfAndFull() {
        #expect(ModalDimension.half.resolveWidth(parent: 401, orientation: .portrait) == 200)
        #expect(ModalDimension.full.resolveHeight(parent: 800, orientation: .portrait) == 800)
    }

    @Test func fixedPercentAndPadding() {
        #expect(ModalDimension.fixed(270).resolveWidth(parent: 400, orientation: .portrait) == 270)
        #expect(ModalDimension.percent(0.2).resolveHeight(parent: 800, orientation: .portrait) == 160)
        #expect(ModalDimension.padding(20).resolveWidth(parent: 400, orientation: .portrait) == 360)
    }

    @Test func orientationAwareDimensions() {
        let dimension = ModalDimension.orientation(portrait: 200, landscape: 300)
        #expect(dimension.resolveWidth(parent: 400, orientation: .portrait) == 200)
        #expect(dimension.resolveWidth(parent: 400, orientation: .landscapeLeft) == 300)
        #expect(dimension.resolveWidth(parent: 250, orientation: .landscapeLeft) == 250)
    }

    @Test func automaticUsesMeasuredValue() {
        #expect(ModalDimension.automatic.resolveWidth(parent: 400, orientation: .portrait, automatic: 123) == 123)
        #expect(ModalDimension.automatic.resolveHeight(parent: 800, orientation: .portrait, automatic: 45) == 45)
    }
}
