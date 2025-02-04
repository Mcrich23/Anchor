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
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var creatingMedication: Medication?
    
    var body: some View {
        List {
            ForEach(medications) { medication in
                MedicationEditorView(medication: medication)
                    .onTapGesture {
                        creatingMedication = medication
                    }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let medication = medications[index]
                    modelContext.delete(medication)
                    try? modelContext.save()
                }
            }
        }
        .overlay(content: {
            if medications.isEmpty {
                VStack {
                    ContentUnavailableView {
                        Text("No Medications")
                    } description: {
                        Text("You haven't added any medications yet.")
                    } actions: {
                        Button("Get Started") {
                            let medication = Medication(name: "", dosage: "", notes: "")
                            self.creatingMedication = medication
                        }
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    let medication = Medication(name: "", dosage: "", notes: "")
                    self.creatingMedication = medication
                } label: {
                    Label("Create Medication", systemImage: "plus.circle")
                }
                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark.circle")
                }
            }
        }
        .sheet(item: $creatingMedication) { item in
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
            VStack {
                Text(medication.name)
                Divider()
                Text(medication.dosage)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MedicationManagementView()
    }
        .modelContainer(for: Medication.self, isAutosaveEnabled: true)
}
