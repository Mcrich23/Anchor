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
            return [
                .homeCircleGradientColor1,
                .homeCircleGradientColor1,
                .homeCircleGradientColor1,
                
                .homeCircleGradientColor3,
                .homeCircleGradientColor2,
                .homeCircleGradientColor3,
                
                .homeCircleGradientColor3,
                .homeCircleGradientColor4,
                .homeCircleGradientColor3,
            ]
        }
        
        return [
            .homeCircleGradientColor1,
            .homeCircleGradientColor2,
            .homeCircleGradientColor1,
            
            .homeCircleGradientColor4,
            .homeCircleGradientColor3,
            .homeCircleGradientColor4,
            
            .homeCircleGradientColor3,
            .homeCircleGradientColor4,
            .homeCircleGradientColor3,
        ]
    }
    
    let bottomAntiCircleGradientColors: [Color] = [
        .homeAntiCircleGradientColor1,
        .homeAntiCircleGradientColor2,
    ]
    
    @State var selectedAnchor: AnchorType?
    
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
                
                VStack(spacing: 10) {
                    if selectedAnchor == nil {
                        VStack {
                            ForEach(AnchorType.allCases, id: \.self) { anchor in
                                Button(anchor.rawValue.capitalized) {
                                    if selectedAnchor == anchor {
                                        selectedAnchor = nil
                                    } else {
                                        selectedAnchor = anchor
                                    }
                                }
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
                    SemiCircle(colors: semiCircleGradientColors)
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
                }
            }
            .background {
                LinearGradient(colors: bottomAntiCircleGradientColors, startPoint: .center, endPoint: .top)
                    .ignoresSafeArea()
            }
            .animation(.default.speed(0.8), value: self.selectedAnchor)
        }
        .environment(\.customDismiss, dismissAction)
    }
    
    func dismissAction() {
        selectedAnchor = nil
    }
}

extension EnvironmentValues {
    
    /// Dismisses to select anchor view
    @Entry var customDismiss: () -> Void = {}
}

private struct AnchorSelectionButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var material: Material {
        switch colorScheme {
        case .dark: .ultraThinMaterial
        default: .regularMaterial
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 150)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
                    .shadow(color: .primary, radius: 3, y: 1)
            }
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
