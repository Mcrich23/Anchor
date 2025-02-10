import SwiftUI
import SwiftData

@main
struct MyApp: App {
    @ObservedObject private var userResponseController = UserResponseController()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            OrientationObservationContainerView()
                .fontDesign(.rounded)
                .modelContainer(for: [MedicationLog.self, MedicationLogMed.self, Medication.self], isAutosaveEnabled: true)
                .environment(\.userInterfaceIdiom, UIDevice.current.userInterfaceIdiom)
                .environmentObject(userResponseController)
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

struct OrientationObservationContainerView: View {
    @State private var orientation = UIDevice.current.orientation
    @State private var previousOrientation: UIDeviceOrientation = UIDevice.current.orientation
    
    var nonFlatOrientation: UIDeviceOrientation {
        self.orientation.isFlat ? self.previousOrientation : self.orientation
    }
    
    var body: some View {
        ContentView()
        .environment(\.orientation, orientation)
        .environment(\.nonFlatOrientation, nonFlatOrientation)
        .onRotate { orientation in
            self.orientation = orientation
        }
        .onChange(of: orientation, initial: true, { oldValue, newValue in
            self.previousOrientation = oldValue
        })
    }
}

extension EnvironmentValues {
    // Cannot set dynamic default because `UIDevice.current` is MainActor only
    @Entry var userInterfaceIdiom: UIUserInterfaceIdiom = .pad
}
