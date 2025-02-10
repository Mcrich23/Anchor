import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @State private var orientation = UIDevice.current.orientation
    @State private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    @ObservedObject private var userResponseController = UserResponseController()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .fontDesign(.rounded)
                .environment(\.userInterfaceIdiom, UIDevice.current.userInterfaceIdiom)
                .environment(\.orientation, orientation)
                .environment(\.nonFlatOrientation, self.orientation.isFlat ? self.previousOrientation : self.orientation)
                .environmentObject(userResponseController)
                .modelContainer(for: [MedicationLog.self, MedicationLogMed.self, Medication.self], isAutosaveEnabled: true)
                .onRotate { orientation in
                    self.orientation = orientation
                }
                .onChange(of: orientation, initial: true, { oldValue, newValue in
                    self.previousOrientation = oldValue
                })
                .onChange(of: scenePhase) { _, newValue in
                    Task {
                        switch newValue {
                        case .active:
                            await userResponseController.appEnteredForeground()
                        case .background:
                            await userResponseController.appEnteredBackground()
                        default: break
                        }
                    }
                }
        }
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var userInterfaceIdiom: UIUserInterfaceIdiom = .pad
}
