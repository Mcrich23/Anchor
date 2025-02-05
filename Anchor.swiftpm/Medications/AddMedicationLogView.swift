//
//  AddMedicationLogView.swift
//  Anchor
//
//  Created by Morris Richman on 2/5/25.
//

import SwiftUI
import SwiftData

struct AddMedicationLogView: View {
    @State var medicationLog: MedicationLog = .init(date: .now, medications: [])
    @Query var medications: [Medication] = []
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State var creatingMedication: Medication?
    @State var isLargeTitleVisible = true
    
    func isTakingMedicationBinding(for medication: Medication) -> Binding<Bool> {
        Binding {
            medicationLog.medications.contains(where: { $0.persistentModelID == medication.persistentModelID })
        } set: { isTaking in
            switch isTaking {
            case true:
                guard !medicationLog.medications.contains(where: { $0.persistentModelID == medication.persistentModelID }) else { return }
                medicationLog.medications.append(medication)
            case false:
                medicationLog.medications.removeAll(where: { $0.persistentModelID == medication.persistentModelID })
            }
        }

    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    DatePicker("", selection: $medicationLog.date)
                        .accessibilityLabel(Text("Entry Date"))
                        .frame(maxWidth: 50, alignment: .leading)
                    Text("Create Entry")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onScrollVisibilityChange { isVisible in
                            self.isLargeTitleVisible = isVisible
                        }
                }
                LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 2), alignment: .center) {
                    ForEach(medications) { medication in
                        MedicationTakingCellView(medication: medication, isTakingMedication: isTakingMedicationBinding(for: medication))
                    }
                }
            }
            .padding()
        }
        .navigationTitle(isLargeTitleVisible ? "" : "Create Entry")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, content: {
            HStack {
                Button {
                    modelContext.insert(medicationLog)
                    dismiss()
                } label: {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .background(.regularMaterial)
        })
        .toolbar {
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

private struct MedicationTakingCellView: View {
    @Bindable var medication: Medication
    @Binding var isTakingMedication: Bool
    
    @ViewBuilder
    var button: some View {
        Button {
            isTakingMedication.toggle()
        } label: {
            Group {
                switch isTakingMedication {
                case true:
                    Label("Taken", systemImage: "checkmark.circle")
                        .labelStyle(.titleAndIcon)
                case false:
                    Label("Taken", systemImage: "checkmark.circle")
                        .labelStyle(.titleOnly)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        GroupBox {
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
                Divider()
                switch isTakingMedication {
                    case true:
                    button
                        .buttonStyle(.borderedProminent)
                case false:
                    button
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}
