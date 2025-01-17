//
//  PATakeActionView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct PATakeActionView: View {
    let shareText: String = "Hello, I am experiencing a panic attack. I am using the app Anchor to help me manage my symptoms. If you don't hear back from me in the next 30 minutes, please call me."
    @Environment(\.geometrySize) var geo
    
    var body: some View {
        VStack {
            Text("Let's Take Some Action")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            if geo.width < 500 {
                VStack(spacing: 15) {
                    boxes
                }
            } else {
                HStack(spacing: 40) {
                    boxes
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var boxes: some View {
        Group {
            box {
                Text("Take your medication")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Taking medication can be integral to managing panic attacks. If you have specific medication, or general anxiety medication, make sure to take it as directed.")
                    .minimumScaleFactor(0.7)
                Button("Take Medication") {
                    
                }
                    .buttonStyle(.borderedProminent)
            }
            .tint(Color.purple)
            box {
                Text("Let Someone Know")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Telling someone that you are experiencing a panic attack can help you keep people aware of your situation and receive immediate help if needed.")
                    .minimumScaleFactor(0.7)
                ShareLink("Share with Someone", items: [shareText])
                    .buttonStyle(.borderedProminent)
            }
        }
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    func box(@ViewBuilder _ view: () -> some View) -> some View {
        VStack(spacing: 20) {
            view()
        }
        .frame(maxWidth: 400, minHeight: 100, maxHeight: 200)
        .padding()
        .background(Color(uiColor: .secondarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
