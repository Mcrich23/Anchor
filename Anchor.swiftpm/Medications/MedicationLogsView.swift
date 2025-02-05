//
//  MedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

struct MedicationLogsView: View {
    @Query var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @State var isShowingAddMedicationLogView: Bool = false
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section(log.date.formatted(date: .abbreviated, time: .standard)) {
                    ForEach(log.medications) { medication in
                        MedicationView(medication: medication)
                    }
                }
            }
        }
        .toolbar {
            Button {
                isShowingAddMedicationLogView.toggle()
            } label: {
                Label("Create Entry", systemImage: "plus.circle")
            }
        }
        .sheet(isPresented: $isShowingAddMedicationLogView) {
            NavigationStack {
                AddMedicationLogView()
            }
        }
    }
}

private struct MedicationView: View {
    @Bindable var medication: Medication
    
    var body: some View {
        ViewThatFits {
            VStack {
                internals
            }
            
            HStack {
                internals
            }
        }
    }
    
    @ViewBuilder
    var internals: some View {
        MedicationCellView(medication: medication)
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
