import SwiftUI

struct ContentView: View {
    let bottomCircleGradientColors: [Color] = [
        .homeCircleGradientColor1,
        .homeCircleGradientColor2,
        .homeCircleGradientColor3,
        .homeCircleGradientColor4,
//        .init(.homeCircleGradientColor5),
//        .init(.homeCircleGradientColor6),
    ]
    
    var semiCircleGradientColors: [Color] {
        guard selectedAnchor != nil else {
            return .semiCircleGradientColorsInHome
        }
        
        return .semiCircleGradientColorsInAnchor
    }
    
    let bottomAntiCircleGradientColors: [Color] = [
        .homeAntiCircleGradientColor1,
        .homeAntiCircleGradientColor2,
    ]
    
    @State var selectedAnchor: AnchorType?
    @State var isShowingMedLog = false
    @State var isShowingSourcesView = false
    @StateObject var meshBackgroundCircleViewModel = AnimatedMeshViewModel()
    @EnvironmentObject var userResponseController: UserResponseController
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Spacer()
                    Image("TransparentAnchor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150, maxHeight: 150)
                    Text("Drop Your Anchor")
                        .font(.headline)
                    Text("Choose an option to find relief techniques.")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .accessibilityHidden(selectedAnchor != nil)
                
                VStack(spacing: 10) {
                    if selectedAnchor == nil {
                        VStack {
                            ForEach(AnchorType.allCases, id: \.self) { anchor in
                                Button(anchor.rawValue.capitalized) {
                                    userResponseController.playSoundEffect(.primaryClick)
                                    if selectedAnchor == anchor {
                                        selectedAnchor = nil
                                    } else {
                                        selectedAnchor = anchor
                                    }
                                }
                                .multilineTextAlignment(.center)
                                .keyboardShortcut(anchor.shortcutKey, modifiers: .command)
//                                .foregroundStyle(anchor.color)
                            }
                        }
                        .buttonStyle(AnchorSelectionButtonStyle())
                        .foregroundStyle(Color.accentColor)
                    }
                    Spacer()
                }
                .allowsHitTesting(selectedAnchor == nil)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(alignment: .top) {
                    SemiCircle(colors: semiCircleGradientColors, animatedMeshViewModel: meshBackgroundCircleViewModel)
                        .foregroundStyle(Gradient(colors: bottomCircleGradientColors))
                        .frame(minWidth: 600, idealWidth: geo.size.width)
                        .frame(height: geo.size.height/1.8)
                        .padding(.top, -20)
                        .ignoresSafeArea()
                        .scaleEffect(x: selectedAnchor == nil ? 1 : 3)
                        .scaleEffect(y: selectedAnchor == nil ? 1 : 3.4)
                        .onAppear {
                            print(geo.size)
                        }
                }
                .padding(.top)
            }
            .overlay {
                if let selectedAnchor {
                    AnchorView(anchor: selectedAnchor)
                        .environment(\.meshCircleSize, geo.size)
                        .environmentObject(meshBackgroundCircleViewModel)
                }
            }
            .background {
                LinearGradient(colors: bottomAntiCircleGradientColors, startPoint: .center, endPoint: .top)
                    .ignoresSafeArea()
            }
        }
        .overlay(alignment: .topLeading, content: {
            if selectedAnchor == nil {
                HStack {
                    Button {
                        isShowingSourcesView = true
                    } label: {
                        Label("See Sources", systemImage: "text.document")
                            .labelStyle(.iconOnly)
                    }
                    .keyboardShortcut(.init("i"), modifiers: .command)
                    Button {
                        isShowingMedLog = true
                    } label: {
                        Label("Medication Log", systemImage: "calendar.day.timeline.left")
                            .labelStyle(.iconOnly)
                    }
                    .keyboardShortcut(.init("l"), modifiers: .command)
                }
                .buttonStyle(.reactive)
                .font(.title2)
                .padding(.leading)
            }
        })
        .overlay(alignment: .bottomTrailing, content: {
            if selectedAnchor == nil {
                AudioPlayerButtonView()
                    .padding(.trailing)
            }
        })
        .sheet(isPresented: $isShowingMedLog, content: {
            NavigationStack {
                MedicationLogsView()
            }
        })
        .sheet(isPresented: $isShowingSourcesView, content: {
            SourcesView()
        })
        .environment(\.customDismiss, dismissAction)
        .animation(.default.speed(0.8), value: self.selectedAnchor)
    }
    
    func dismissAction() {
        selectedAnchor = nil
    }
}

extension EnvironmentValues {
    
    /// Dismisses to select anchor view
    @Entry var customDismiss: () -> Void = {}
    
    @Entry var meshCircleSize: CGSize = .zero
}
