//
//  MedicationManagementView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

struct MedicationManagementView: View {
    @Query var medications: [Medication] = []
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            ForEach(medications) { medication in
                MedicationEditorView(medication: medication)
            }
        }
        .toolbar {
            Button {
                let medication = Medication(name: "", dosage: "")
                modelContext.insert(medication)
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

private struct MedicationEditorView: View {
    @Bindable var medication: Medication
    
    var body: some View {
        Section {
            TextField("Name", text: $medication.name)
            TextField("Dosage", text: $medication.dosage)
        }
    }
}

#Preview {
    NavigationStack {
        MedicationManagementView()
    }
        .modelContainer(for: Medication.self, isAutosaveEnabled: true)
}
