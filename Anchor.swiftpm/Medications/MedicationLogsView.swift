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
        Text(medication.name)
        Text(medication.dosage)
            .font(.callout)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
