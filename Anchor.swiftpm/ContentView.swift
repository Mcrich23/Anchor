import SwiftUI

struct ContentView: View {
    let bottomCircleGradientColors: [Color] = [
        .init(.homeCircleGradientColor1),
        .init(.homeCircleGradientColor2),
        .init(.homeCircleGradientColor3),
        .init(.homeCircleGradientColor4),
//        .init(.homeCircleGradientColor5),
//        .init(.homeCircleGradientColor6),
    ]
    
    let bottomAntiCircleGradientColors: [Color] = [
        .init(.homeAntiCircleGradientColor1),
        .init(.homeAntiCircleGradientColor2),
    ]
    
    @State var selectedAnchor: AnchorType?
    @Namespace var namespace
    
    var anchorBackgroundGradientStops: [Gradient.Stop] {
        guard bottomCircleGradientColors.count > 1 else { return [] }
        
        let topHalf = bottomCircleGradientColors.prefix(bottomCircleGradientColors.count/2).enumerated().map { index, color in
            Gradient.Stop(color: color, location: (CGFloat(index)/(CGFloat(bottomCircleGradientColors.count)/2))*1.3)
        }
        
        let topHalfLocationDensity = topHalf.map(\.location).reduce(0, +)
        
        return topHalf + [Gradient.Stop(color: bottomCircleGradientColors.last!, location: 1)]
    }
    
    var body: some View {
        NavigationStack {
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
                        if let selectedAnchor {
                            VStack {
                                Text("Selected Anchor")
                                    .font(.headline)
                                Text("\(selectedAnchor.rawValue)")
                                Button("Back") {
                                    self.selectedAnchor = nil
                                }
                            }
                        } else {
                            VStack {
                                ForEach(AnchorType.allCases, id: \.self) { anchor in
                                    Button(anchor.rawValue.capitalized) {
                                        if selectedAnchor == anchor {
                                            selectedAnchor = nil
                                        } else {
                                            selectedAnchor = anchor
                                        }
                                    }
                                }
                            }
                            .buttonStyle(AnchorSelectionButtonStyle())
                            .foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(alignment: .top) {
                        Circle()
                            .fill(selectedAnchor == nil ? Gradient(colors: bottomCircleGradientColors) : Gradient(stops: anchorBackgroundGradientStops))
                            .scaledToFill()
                            .padding(.top, -15)
                        //                                    .scaleEffect(x: 1.5)
                            .offset(y: selectedAnchor == nil ? 0 : -geo.size.height/5)
                            .scaleEffect(x: selectedAnchor == nil ? 1.5 : 1.7)
                            .scaleEffect(y: selectedAnchor == nil ? 1 : 1.8)
                            .matchedGeometryEffect(id: "selector_background", in: namespace)
                        //                        .shadow(color: .primary, radius: 3, y: 1)
                    }
                    .padding(.top)
                    //                }
                }
            }
            .background {
                LinearGradient(colors: bottomAntiCircleGradientColors, startPoint: .center, endPoint: .top)
                    .ignoresSafeArea()
            }
            .animation(.default.speed(0.8), value: self.selectedAnchor)
        }
    }
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
