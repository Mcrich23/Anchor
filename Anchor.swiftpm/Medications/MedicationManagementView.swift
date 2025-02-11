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
                Section {
                    Button {
                        creatingMedication = medication
                    } label: {
                        MedicationCellView(medication: medication)
                    }
                    .buttonStyle(.reactive)
                    .foregroundStyle(.primary, .secondary, .tertiary)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let medication = medications[index]
                    modelContext.delete(medication)
                }
                
                try? modelContext.save()
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
                            let medication = Medication.blank
                            self.creatingMedication = medication
                        }
                        .buttonBorderShape(.roundedRectangle)
                        .buttonStyle(.reactiveBorderedProminent)
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
                    let medication = Medication.blank
                    self.creatingMedication = medication
                } label: {
                    Label("Create Medication", systemImage: "plus.circle")
                }
                .buttonStyle(.reactive)
                Button {
                    dismiss()
                } label: {
                    Label("Close", systemImage: "xmark.circle")
                }
                .buttonStyle(.reactive)
            }
        }
        .sheet(item: $creatingMedication) { item in
            NavigationStack {
                CreateMedicationView(medication: item, in: modelContext)
            }
        }
    }
}

struct MedicationCellView: View {
    @Bindable var medication: Medication
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack {
                    Text(medication.name)
                    Spacer()
                    Text(medication.dosage)
                        .padding(.vertical, 3)
                        .padding(.horizontal)
                        .background(Color.dynamicColor(light: .secondarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
                }
                if !medication.notes.isEmpty {
                    Divider()
                    Text(medication.notes)
                        .textSelection(.enabled)
                        .foregroundStyle(.secondary)
                }
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
