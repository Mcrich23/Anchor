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
    @State var creatingMedication: Medication?
    
    var body: some View {
        List {
            ForEach(medications) { medication in
                MedicationEditorView(medication: medication)
            }
        }
        .toolbar {
            Button {
                let medication = Medication(name: "", dosage: "", notes: "")
                self.creatingMedication = medication
            } label: {
                Image(systemName: "plus.circle")
            }
        }
        .sheet(item: $creatingMedication) {
            guard let creatingMedication, !creatingMedication.name.isEmpty else { return }
            modelContext.insert(creatingMedication)
            self.creatingMedication = nil
        } content: { item in
            NavigationStack {
                CreateMedicationView(medication: item)
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
