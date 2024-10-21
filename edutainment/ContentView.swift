import SwiftUI

struct ContentView: View {
    @State private var showWelcomeScreen = true

    var body: some View {
        NavigationStack {
            if showWelcomeScreen {
                WelcomeScreen()
            } else {
                TableSelectionScreen()
            }
        }
    }
}
