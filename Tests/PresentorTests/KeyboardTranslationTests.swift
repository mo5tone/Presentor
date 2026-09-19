import Foundation
@testable import Presentor
import Testing

struct KeyboardTranslationTests {
    private let container = CGRect(x: 0, y: 0, width: 400, height: 800)
    private let keyboard = CGRect(x: 0, y: 500, width: 400, height: 300)

    @Test func noneReturnsUnchanged() {
        let frame = CGRect(x: 100, y: 600, width: 200, height: 200)
        let result = KeyboardTranslation.none.calculate(keyboardFrame: keyboard,
                                                        presentedFrame: frame,
                                                        containerFrame: container)
        #expect(result.frame == frame)
        #expect(result.yOffset == 0)
    }

    @Test func moveUpShiftsJustAboveKeyboard() {
        let frame = CGRect(x: 100, y: 600, width: 200, height: 200)
        let result = KeyboardTranslation.moveUp.calculate(keyboardFrame: keyboard,
                                                          presentedFrame: frame,
                                                          containerFrame: container)
        #expect(result.frame == CGRect(x: 100, y: 300, width: 200, height: 200))
        #expect(result.yOffset == 300)
    }

    @Test func compressKeepsFrameWhenPinnedToBottomEdge() {
        let frame = CGRect(x: 100, y: 600, width: 200, height: 200)
        let result = KeyboardTranslation.compress.calculate(keyboardFrame: keyboard,
                                                            presentedFrame: frame,
                                                            containerFrame: container)
        #expect(result.frame == CGRect(x: 100, y: 300, width: 200, height: 200))
        #expect(result.yOffset == 0)
    }

    @Test func customPaddingIsUsedWhenNotFullScreen() {
        let frame = CGRect(x: 100, y: 500, width: 200, height: 200)
        let result = KeyboardTranslation(.moveUp, padding: 20).calculate(keyboardFrame: keyboard,
                                                                         presentedFrame: frame,
                                                                         containerFrame: container)
        // keyboardTop = 500, presentedViewBottom = 700 + 20 = 720, offset = 220
        #expect(result.frame.origin.y == 280)
        #expect(result.yOffset == 220)
    }

    @Test func noTranslationWhenAlreadyClear() {
        let frame = CGRect(x: 100, y: 100, width: 200, height: 100)
        let result = KeyboardTranslation.moveUp.calculate(keyboardFrame: keyboard,
                                                          presentedFrame: frame,
                                                          containerFrame: container)
        #expect(result.frame == frame)
    }
}
