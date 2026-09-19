import Foundation
import Testing
@testable import Presentor

@Suite struct ModalPositionTests {
    private let container = CGRect(x: 0, y: 0, width: 400, height: 800)
    private let size = CGSize(width: 100, height: 100)

    @Test func screenCenter() {
        let origin = ModalPosition.center(.screen).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(origin == CGPoint(x: 150, y: 350))
    }

    @Test func topAndBottomCenter() {
        let top = ModalPosition.center(.top).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(top == CGPoint(x: 150, y: 149))

        let bottom = ModalPosition.center(.bottom).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(bottom == CGPoint(x: 150, y: 550))
    }

    @Test func customOrigin() {
        let origin = ModalPosition.origin(CGPoint(x: 10, y: 20)).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(origin == CGPoint(x: 10, y: 20))
    }

    @Test func edgePositions() {
        let bottom = ModalPosition.edge(.bottom(padding: 10)).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(bottom == CGPoint(x: 150, y: 690))

        let topLeft = ModalPosition.edge(.topLeft(padding: 5)).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(topLeft == CGPoint(x: 5, y: 5))

        let bottomRight = ModalPosition.edge(.bottomRight(padding: 0)).calculateOrigin(presentedSize: size, containerFrame: container)
        #expect(bottomRight == CGPoint(x: 300, y: 700))
    }
}
