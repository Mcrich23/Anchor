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
    
    var body: some View {
        NavigationStack {
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
                    NavigationLink("Migraine", destination: Text("Migraine"))
                    NavigationLink("Panic Attack", destination: Text("Panic Attack"))
                    Spacer()
                }
                .buttonStyle(AnchorSelectionButtonStyle())
                .foregroundStyle(Color.accentColor)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(alignment: .top) {
                    Circle()
                        .fill(Gradient(colors: bottomCircleGradientColors))
                        .scaledToFill()
                        .padding(.top, -15)
                        .scaleEffect(x: 1.5)
//                        .shadow(color: .primary, radius: 3, y: 1)
                }
                .padding(.top)
            }
            .background {
                LinearGradient(colors: bottomAntiCircleGradientColors, startPoint: .center, endPoint: .top)
                    .ignoresSafeArea()
            }
        }
    }
}

private struct AnchorSelectionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 150)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.clear)
                    .shadow(color: .primary, radius: 3, y: 1)
            }
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
