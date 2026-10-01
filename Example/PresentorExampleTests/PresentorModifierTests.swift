import Presentor
import SwiftUI
import Testing
import UIKit

/// End-to-end coverage for the `.presentor(...)` SwiftUI modifiers.
///
/// The modifiers drive a hidden `PresenterViewController` anchor sitting in
/// `.background`. UIKit forwards `present` from that anchor to the enclosing
/// `UIHostingController`, so the anchor must never own the presentation and must
/// never define the presentation geometry.
///
/// These run in the example app's test target because UIKit presentations need a
/// live window scene.
///
/// Waits must yield the main actor: the modifiers defer presentation with
/// `DispatchQueue.main.async`, which a `RunLoop.run(until:)` spinner does not
/// drain under swift-testing, making the modifier look like a no-op.
@MainActor
struct PresentorModifierTests {
    @Test func isPresentedPresentsAndDismisses() async throws {
        let state = ModifierState()
        let hosting = UIHostingController(rootView: BoolModifierRoot(state: state))
        let window = makeWindow(root: hosting)
        defer { window.isHidden = true }
        hosting.view.layoutIfNeeded()
        let anchor = try #require(anchor(in: hosting))

        state.isPresented = true
        let presented = try #require(await presentedController(of: anchor))
        let presentingIsHosting = presented.presentingViewController === hosting
        let fillsContainer = presented.view.superview?.frame == window.bounds

        state.isPresented = false
        let dismissed = await waitUntil { anchor.presentedViewController == nil }

        #expect(presentingIsHosting)
        #expect(fillsContainer)
        #expect(dismissed)
    }

    @Test func itemPresentsUpdatesAndDismisses() async throws {
        let state = ModifierState()
        let hosting = UIHostingController(rootView: ItemModifierRoot(state: state))
        let window = makeWindow(root: hosting)
        defer { window.isHidden = true }
        hosting.view.layoutIfNeeded()
        let anchor = try #require(anchor(in: hosting))

        _ = await waitUntil(timeout: 0.4) { anchor.presentedViewController != nil }
        let idleWhileNil = anchor.presentedViewController == nil

        state.item = ModifierItem(id: "A")
        let first = try #require(await presentedController(of: anchor))
        let presentingIsHosting = first.presentingViewController === hosting

        state.item = ModifierItem(id: "B")
        try? await Task.sleep(nanoseconds: 300_000_000)
        let afterItemChange = anchor.presentedViewController

        state.item = nil
        let dismissed = await waitUntil { anchor.presentedViewController == nil }

        #expect(idleWhileNil)
        #expect(presentingIsHosting)
        #expect(afterItemChange === first, "Changing the item reuses the presented host")
        #expect(dismissed)
    }
}

// MARK: - Fixtures

private struct ModifierItem: Identifiable, Equatable {
    let id: String
}

@MainActor
private final class ModifierState: ObservableObject {
    @Published var isPresented = false
    @Published var item: ModifierItem?
}

private struct BoolModifierRoot: View {
    @ObservedObject var state: ModifierState

    var body: some View {
        Color.clear
            .frame(width: 10, height: 10)
            .presentor(isPresented: $state.isPresented, presentation: .popup) {
                Text("bool").padding(20).background(Color.white)
            }
    }
}

private struct ItemModifierRoot: View {
    @ObservedObject var state: ModifierState

    var body: some View {
        Color.clear
            .frame(width: 10, height: 10)
            .presentor(item: $state.item, presentation: .bottomCard) { item in
                Text(item.id).padding(20).background(Color.white)
            }
    }
}

// MARK: - Helpers

/// The `PresenterViewController` anchor the modifier installs in `.background`.
@MainActor
private func anchor(in hosting: UIViewController) -> UIViewController? {
    var stack = hosting.children
    while let next = stack.popLast() {
        if String(describing: type(of: next)).contains("PresenterViewController") {
            return next
        }
        stack.append(contentsOf: next.children)
    }
    return nil
}

@MainActor
private func presentedController(of anchor: UIViewController,
                                 timeout: TimeInterval = 3) async -> UIViewController?
{
    _ = await waitUntil(timeout: timeout) { anchor.presentedViewController != nil }
    return anchor.presentedViewController
}

@MainActor
private func waitUntil(timeout: TimeInterval = 3, _ condition: () -> Bool) async -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while !condition(), Date() < deadline {
        try? await Task.sleep(nanoseconds: 20_000_000)
    }
    return condition()
}

@MainActor
private func makeWindow(root: UIViewController) -> UIWindow {
    let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    let window: UIWindow = if let scene {
        UIWindow(windowScene: scene)
    } else {
        UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
    }
    window.overrideUserInterfaceStyle = .light
    window.rootViewController = root
    window.makeKeyAndVisible()
    window.layoutIfNeeded()
    return window
}
