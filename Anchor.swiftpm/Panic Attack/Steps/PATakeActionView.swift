//
//  PATakeActionView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct PATakeActionView: View {
    var body: some View {
        VStack {
            Text("Let's Take Some Action")
                .font(.largeTitle)
                .bold()
            HStack(spacing: 40) {
                box {
                    Text("Take your medication.")
                }
                box {
                    Text("Let Someone Know")
                        .font(.title)
                        .bold()
                    Text("Telling someone that you are experiencing a panic attack can help you keep people aware of your situation and receive immediate help if needed.")
                    ShareLink("Share with Someone", items: ["Hello, I am experiencing a panic attack!"])
                        .buttonStyle(.borderedProminent)
                }
            }
            .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    @ViewBuilder
    func box(@ViewBuilder _ view: () -> some View) -> some View {
        VStack(spacing: 20) {
            view()
        }
        .frame(maxWidth: 400, maxHeight: 200)
        .padding()
        .background(Color(uiColor: .secondarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
