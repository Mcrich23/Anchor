//
//  MTakeActionView.swift
//  Anchor
//
//  Created by Morris Richman on 1/16/25.
//

import Foundation
import SwiftUI

struct MTakeActionView: View {
    let shareText: String = "Hello, I am experiencing a migraine. I am using the app Anchor to help me manage my symptoms. If you don't hear back from me in the next 30 minutes, please call me."
    @Environment(\.geometrySize) var geo
    @Environment(\.meshCircleSize) var meshCircleSize
    @EnvironmentObject var meshBackgroundCircleViewModel: AnimatedMeshViewModel
    @State var isShowingAddMedicationLogEntry: MedicationLog? = .blank
    @State var isShowingMedicationLog = false
    @Environment(\.modelContext) var modelContext
    
    let gradientColors: [Color] = [
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
    
    @ViewBuilder
    var meshGradientBackground: some View {
        SemiCircle(colors: gradientColors, animatedMeshViewModel: meshBackgroundCircleViewModel)
            .foregroundStyle(Gradient(colors: gradientColors))
            .frame(minWidth: 600, idealWidth: meshCircleSize.width)
            .frame(height: meshCircleSize.height/1.8)
            .ignoresSafeArea()
            .scaleEffect(x: 3)
            .scaleEffect(y:  3.4)
            .position(x: meshCircleSize.width/2, y: meshCircleSize.height/2)
    }
    
    var body: some View {
        VStack {
            Text("Take Medication")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Taking medication can be integral to managing migraines. If you have specific medication, or general pain medication, make sure to take it as directed.")
                .minimumScaleFactor(0.7)
            NavigationStack {
                    if let isShowingAddMedicationLogEntry {
//                        Text("Hi")
                        AddMedicationLogView(medicationLog: isShowingAddMedicationLogEntry, in: modelContext)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .environment(\.customDismiss, { self.isShowingAddMedicationLogEntry = nil })
                            .background(.ultraThinMaterial)
                            .background {
                                meshGradientBackground
                            }
                            .scrollContentBackground(.hidden)
                    } else {
                        MedicationLogsView()
                            .background(.ultraThinMaterial)
                            .background {
                                meshGradientBackground
                            }
                            .scrollContentBackground(.hidden)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .animation(.default, value: isShowingAddMedicationLogEntry)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var boxes: some View {
        Group {
            box {
                Text("Take Medication")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Taking medication can be integral to managing migraines. If you have specific medication, or general pain medication, make sure to take it as directed.")
                    .minimumScaleFactor(0.7)
                HStack {
                    Button("Take Medication") {
                        isShowingAddMedicationLogEntry = .blank
                    }
                    .buttonStyle(.borderedProminent)
                    Button {
                        isShowingMedicationLog.toggle()
                    } label: {
                        Label("Medication Log", systemImage: "calendar.day.timeline.left")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.reliefNavigation)
                }
            }
        }
        .multilineTextAlignment(.center)
    }
    
    @ViewBuilder
    func box(@ViewBuilder _ view: () -> some View) -> some View {
        VStack(spacing: 20) {
            view()
        }
//        .frame(maxWidth: 800, minHeight: 100, maxHeight: 800)
        .padding()
        .background(Color(uiColor: .secondarySystemFill).opacity(0))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
