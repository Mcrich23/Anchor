//
//  MedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

struct MedicationLogsView: View {
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty }) var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @State var isShowingAddMedicationLogView: Bool = false
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section(log.date.formatted(date: .abbreviated, time: .standard)) {
                    ForEach(log.medications) { medication in
                        MedicationCellView(medication: medication)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let log = medicationLogs[index]
                    modelContext.delete(log)
                    
                    try? modelContext.save()
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    isShowingAddMedicationLogView.toggle()
                } label: {
                    Label("Create Entry", systemImage: "plus.circle")
                }
            }
        }
        .sheet(isPresented: $isShowingAddMedicationLogView) {
            NavigationStack {
                AddMedicationLogView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
