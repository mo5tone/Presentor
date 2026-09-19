import Presentor
import SnapshotTesting
import SwiftUI
import Testing
import UIKit
@testable import PresentorExample

/// App-hosted image snapshots of the presentation chrome + presented content.
///
/// These run in the example app's test target because UIKit presentations need a
/// live window scene, which a plain SwiftPM logic-test host does not provide.
/// References are stored under `Example/PresentorExampleTests/__Snapshots__`.
/// Re-record after intentional visual changes with `withSnapshotTesting(record: .all) { ... }`.
@MainActor
@Suite struct PresentationSnapshotTests {
    @Test func alert() throws {
        let window = try #require(presenting(.alert))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func popup() throws {
        let window = try #require(presenting(.popup))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func bottomCard() throws {
        let window = try #require(presenting(.bottomCard))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func topHalf() throws {
        let window = try #require(presenting(.topHalf))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func bottomHalf() throws {
        let window = try #require(presenting(.bottomHalf))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func customFloatingCard() throws {
        let window = try #require(presenting(.floatingCard, contentBackground: .white))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }

    @Test func dynamicSwiftUI() throws {
        let content = UIHostingController(rootView: DynamicSnapshotView())
        let window = try #require(presenting(.dynamic(), content: content))
        defer { window.isHidden = true }
        let container = try #require(containerView(of: window))
        assertSnapshot(of: container, as: .image)
    }
}

private struct DynamicSnapshotView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Dynamic sizing")
                .font(.headline)
            Text("Sized by content.")
                .font(.subheadline)
        }
        .padding(24)
        .background(Color.white)
    }
}

private func containerView(of window: UIWindow) -> UIView? {
    window.rootViewController?.presentedViewController?.view.superview
}

/// Presents a solid-colored controller with `presentation`.
@MainActor
private func presenting(_ presentation: Presentation, contentBackground: UIColor = .systemRed) -> UIWindow? {
    let content = UIViewController()
    content.view.backgroundColor = contentBackground
    return presenting(presentation, content: content)
}

/// Presents `content` with `presentation` and returns the window, or `nil` if
/// the presentation never took place.
@MainActor
private func presenting(_ presentation: Presentation, content: UIViewController) -> UIWindow? {
    let window = makeWindow()
    let root = window.rootViewController!

    root.present(content, using: presentation, animated: false)

    let deadline = Date().addingTimeInterval(2)
    while content.view.superview == nil, Date() < deadline {
        RunLoop.current.run(until: Date().addingTimeInterval(0.02))
    }
    window.layoutIfNeeded()

    return content.view.superview == nil ? nil : window
}

@MainActor
private func makeWindow() -> UIWindow {
    let scene = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    let window: UIWindow
    if let scene {
        window = UIWindow(windowScene: scene)
    } else {
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
    }

    window.overrideUserInterfaceStyle = .light
    let root = UIViewController()
    root.view.backgroundColor = .white
    window.rootViewController = root
    window.makeKeyAndVisible()
    window.layoutIfNeeded()
    return window
}
