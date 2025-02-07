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
    @State var isShowingAddMedicationLogEntry: MedicationLog?
    @State var isShowingMedicationLog = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Text("Let's Take Some Action")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            ViewThatFits {
                VStack(spacing: 15) {
                    boxes
                }
                
                HStack(spacing: 40) {
                    boxes
                }
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $isShowingMedicationLog, content: {
            NavigationStack {
                MedicationLogsView()
            }
        })
        .sheet(item: $isShowingAddMedicationLogEntry, content: { item in
            NavigationStack {
                AddMedicationLogView(medicationLog: item, in: modelContext)
            }
        })
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
        .frame(maxWidth: 400, minHeight: 100, maxHeight: 200)
        .padding()
        .background(Color(uiColor: .secondarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
