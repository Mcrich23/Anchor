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
    @State var isShowingAddMedicationLogEntry: MedicationLog? = .blank
    @State var isShowingMedicationLog = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
//            Text("Let's Take Some Action")
//                .font(.largeTitle)
//                .fontWeight(.semibold)
//                .multilineTextAlignment(.center)
            Text("Take Medication")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Taking medication can be integral to managing migraines. If you have specific medication, or general pain medication, make sure to take it as directed.")
                .minimumScaleFactor(0.7)
//            ViewThatFits {
//                VStack(spacing: 15) {
//                    boxes
//                }
//                
//                HStack(spacing: 40) {
//                    boxes
//                }
//            }
//            box {
                NavigationStack {
                    if let isShowingAddMedicationLogEntry {
                        AddMedicationLogView(medicationLog: isShowingAddMedicationLogEntry, in: modelContext)
                            .environment(\.customDismiss, { self.isShowingAddMedicationLogEntry = nil })
                    } else {
                        MedicationLogsView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 6))
//                .background(Color(uiColor: .secondarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
                .animation(.default, value: isShowingAddMedicationLogEntry)
//            }
        }
        .padding(.horizontal)
//        .sheet(item: $isShowingAddMedicationLogEntry, content: { item in
//            NavigationStack {
//                AddMedicationLogView(medicationLog: item, in: modelContext)
//            }
//        })
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
