//
//  PADrawingView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import SwiftUI
import PencilKit

struct PADrawingView: View {
    @Environment(PAStepManager.self) var stepManager
    @State private var isShowingPicker = true
    @State private var canvasBackgroundColor = Color(uiColor: .systemBackground)//Color(.homeAntiCircleGradientColor1)
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Sketch Something")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                }
                Text("Drawing something can help you direct your focus away from the panic attack and therefore reduce its intensity.")
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding([.horizontal, .bottom])
//                .overlay(alignment: .trailing) {
//                    HStack {
//                        if canvasBackgroundColor != Color(.homeAntiCircleGradientColor1) {
//                            Button("Reset") {
//                                canvasBackgroundColor = Color(.homeAntiCircleGradientColor1)
//                            }
//                        }
//                        ColorPicker("", selection: $canvasBackgroundColor)
//                            .accessibilityLabel(Text("Background Color Picker"))
//                            .padding([.bottom, .trailing])
//                    }
//                }
            PencilCanvasView(isShowingPicker: isShowingPicker, backgroundColor: canvasBackgroundColor)
                .onChange(of: stepManager.step, initial: true) { _, newValue in
                    self.isShowingPicker = newValue == .drawing
                }
        }
        .padding(.horizontal)
    }
}

private struct PencilCanvasView: UIViewRepresentable {
    let isShowingPicker: Bool
    let backgroundColor: Color
    let picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.backgroundColor = .init(backgroundColor)
        picker.addObserver(uiView)
        picker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            switch isShowingPicker {
                case true:
                uiView.becomeFirstResponder()
            case false:
                uiView.resignFirstResponder()
            }
        }
    }
}

