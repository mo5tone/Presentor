//
//  PresentorModifier.swift
//  Presentor
//
//  Based on Presentr (MIT). See NOTICE.md.
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

public extension View {
    /// Presents SwiftUI content as a sized and positioned modal.
    ///
    /// ```swift
    /// Button("Show") { isPresented = true }
    ///     .presentor(isPresented: $isPresented, presentation: .popup) {
    ///         MyView()
    ///     }
    /// ```
    func presentor<Content: View>(isPresented: Binding<Bool>,
                                  presentation: Presentation = .popup,
                                  @ViewBuilder content: @escaping () -> Content) -> some View {
        background(
            PresentorPresenter(isPresented: isPresented,
                               presentation: presentation,
                               content: { AnyView(content()) })
        )
    }

    /// Presents SwiftUI content as a sized and positioned modal driven by an item.
    func presentor<Item: Identifiable, Content: View>(item: Binding<Item?>,
                                                      presentation: Presentation = .popup,
                                                      @ViewBuilder content: @escaping (Item) -> Content) -> some View {
        let isPresented = Binding(
            get: { item.wrappedValue != nil },
            set: { newValue in
                if !newValue {
                    item.wrappedValue = nil
                }
            }
        )

        return background(
            PresentorPresenter(isPresented: isPresented,
                               presentation: presentation,
                               content: {
                                   if let value = item.wrappedValue {
                                       AnyView(content(value))
                                   } else {
                                       AnyView(EmptyView())
                                   }
                               })
        )
    }
}

private struct PresentorPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let presentation: Presentation
    let content: () -> AnyView

    func makeUIViewController(context: Context) -> PresenterViewController {
        PresenterViewController()
    }

    func updateUIViewController(_ viewController: PresenterViewController, context: Context) {
        viewController.update(isPresented: isPresented,
                              presentation: presentation,
                              content: content,
                              onDismiss: { isPresented = false })
    }
}

private final class PresenterViewController: UIViewController {
    private var host: DismissReportingHostingController?

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        self.view = view
    }

    func update(isPresented: Bool,
                presentation: Presentation,
                content: @escaping () -> AnyView,
                onDismiss: @escaping () -> Void) {
        // Defer so we never present or dismiss during a SwiftUI update pass.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if isPresented {
                if let host = self.host {
                    host.rootView = content()
                    return
                }

                let host = DismissReportingHostingController(rootView: content())
                host.view.backgroundColor = .clear
                host.onDismiss = { [weak self] in
                    onDismiss()
                    self?.host = nil
                }
                self.host = host
                self.present(host, using: presentation, animated: true)
            } else if let host = self.host {
                self.host = nil
                host.dismiss(animated: true)
            }
        }
    }
}

private final class DismissReportingHostingController: UIHostingController<AnyView> {
    var onDismiss: (() -> Void)?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || presentingViewController == nil {
            onDismiss?()
        }
    }
}
#endif
