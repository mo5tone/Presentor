import Presentor
import SwiftUI

struct ContentView: View {
    @State private var isPresented = false
    @State private var presentation = Presentation.popup
    @State private var contentBackground: Color = Color(.systemBackground)
    @State private var isDynamicPresented = false

    var body: some View {
        NavigationView {
            List {
                section("Presets") {
                    button("Alert", .alert)
                    button("Popup", .popup)
                    button("Top half", .topHalf)
                    button("Bottom half", .bottomHalf)
                    button("Bottom card", .bottomCard)
                    button("Full screen", .fullScreen)
                }

                section("Custom") {
                    button("Floating card", .floatingCard, background: .white)
                }

                section("Dynamic") {
                    Button("Dynamic (Auto Layout)") {
                        isDynamicPresented = true
                    }
                }
            }
            .navigationTitle("Presentor")
        }
        .presentor(isPresented: $isPresented, presentation: presentation) {
            PopupContent(background: contentBackground, dismiss: { isPresented = false })
        }
        .presentor(isPresented: $isDynamicPresented, presentation: .dynamic()) {
            DynamicCard(dismiss: { isDynamicPresented = false })
        }
    }

    private func button(_ title: String,
                        _ presentation: Presentation,
                        background: Color = Color(.systemBackground)) -> some View {
        Button(title) {
            self.presentation = presentation
            self.contentBackground = background
            isPresented = true
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        Section(title) { content() }
    }
}

private struct PopupContent: View {
    let background: Color
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Presentor")
                .font(.title.bold())
            Text("A modern custom presentation library.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Dismiss", action: dismiss)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(background)
    }
}

/// Intrinsically sized so it can demonstrate `.dynamic()` Auto Layout sizing.
private struct DynamicCard: View {
    let dismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Dynamic sizing")
                .font(.headline)
            Text("This card is sized by its SwiftUI content.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button("Dismiss", action: dismiss)
                .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .background(Color(.systemBackground))
    }
}
