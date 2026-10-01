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
        func presentor(isPresented: Binding<Bool>,
                       presentation: Presentation = .popup,
                       @ViewBuilder content: @escaping () -> some View) -> some View
        {
            background(
                PresentorHost(value: isPresented.optional,
                              presentation: presentation,
                              content: { _ in content() })
            )
        }

        /// Presents SwiftUI content as a sized and positioned modal driven by an item.
        func presentor<Item: Identifiable>(item: Binding<Item?>,
                                           presentation: Presentation = .popup,
                                           @ViewBuilder content: @escaping (Item) -> some View) -> some View
        {
            background(
                PresentorHost(value: item,
                              presentation: presentation,
                              content: content)
            )
        }
    }

    /// Bridges an optional source of truth to `PresenterViewController`: a
    /// non-`nil` value presents, `nil` dismisses.
    private struct PresentorHost<Value, Content: View>: UIViewControllerRepresentable {
        @Binding var value: Value?
        let presentation: Presentation
        let content: (Value) -> Content

        func makeUIViewController(context _: Context) -> PresenterViewController<Content> {
            PresenterViewController()
        }

        func updateUIViewController(_ viewController: PresenterViewController<Content>, context _: Context) {
            if let value {
                viewController.presentIfNeeded(presentation: presentation,
                                               content: { content(value) },
                                               onDismiss: { self.$value.wrappedValue = nil })
            } else {
                viewController.dismiss()
            }
        }
    }

    private extension Binding where Value == Bool {
        /// `true` while presenting, `nil` once dismissed.
        var optional: Binding<Bool?> {
            Binding<Bool?>(get: { wrappedValue ? true : nil },
                           set: { wrappedValue = $0 ?? false })
        }
    }

    private final class PresenterViewController<Content: View>: UIViewController {
        private var host: DismissReportingHostingController<Content>?

        override func loadView() {
            let view = UIView()
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = false
            self.view = view
        }

        func presentIfNeeded(presentation: Presentation,
                             content: @escaping () -> Content,
                             onDismiss: @escaping () -> Void)
        {
            // Defer so we never present during a SwiftUI update pass.
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }

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
                present(host, using: presentation, animated: true)
            }
        }

        func dismiss() {
            DispatchQueue.main.async { [weak self] in
                guard let self, let host else { return }
                self.host = nil
                host.dismiss(animated: true)
            }
        }
    }

    private final class DismissReportingHostingController<Content: View>: UIHostingController<Content> {
        var onDismiss: (() -> Void)?

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            if isBeingDismissed || presentingViewController == nil {
                onDismiss?()
            }
        }
    }
#endif
