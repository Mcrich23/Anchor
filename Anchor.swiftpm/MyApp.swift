import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
                .environment(\.userInterfaceIdiom, UIDevice.current.userInterfaceIdiom)
        }
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var userInterfaceIdiom: UIUserInterfaceIdiom = .pad
}
