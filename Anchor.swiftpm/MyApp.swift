import SwiftUI
import SwiftData

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
                .environment(\.userInterfaceIdiom, UIDevice.current.userInterfaceIdiom)
                .modelContainer(for: [MedicationLog.self, Medication.self], isAutosaveEnabled: false)
        }
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var userInterfaceIdiom: UIUserInterfaceIdiom = .pad
}
