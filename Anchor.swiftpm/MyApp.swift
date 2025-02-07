import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @State var orientation = UIDevice.current.orientation
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
                .environment(\.userInterfaceIdiom, UIDevice.current.userInterfaceIdiom)
                .environment(\.orientation, orientation)
                .modelContainer(for: [MedicationLog.self, MedicationLogMed.self, Medication.self], isAutosaveEnabled: true)
                .onRotate { orientation in
                    self.orientation = orientation
                }
        }
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var userInterfaceIdiom: UIUserInterfaceIdiom = .pad
}
