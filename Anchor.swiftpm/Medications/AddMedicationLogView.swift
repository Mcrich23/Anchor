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
    @State var scrollOffset: CGPoint = .zero
    var toolbarOpacity: CGFloat {
        let threshold: CGFloat = 30
        
        guard scrollOffset.y > threshold else { return 0 }
        
        return min(((scrollOffset.y-threshold)/30), 1)
    }
    
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
    
    var halfMedicationsCount: Int {
        Int((Double(medications.count)/2).rounded(.up))
    }
    
    var body: some View {
        OffsetObservingScrollView(offset: $scrollOffset) {
            VStack {
                Text("Create Entry")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                LazyVStack {
                    ForEach(0..<halfMedicationsCount, id: \.self) { i in
                        if i < medications.count-1 {
                            MedicationTakingDualCellLayout(medication1: medications[i], medication2: medications[i+1], isTakingMedicationBinding: isTakingMedicationBinding)
                        } else {
                            MedicationTakingDualCellLayout(medication1: medications[i], medication2: nil, isTakingMedicationBinding: isTakingMedicationBinding)
                        }
                    }
                }
            }
            .padding()
        }
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
            ToolbarItemGroup(placement: .topBarLeading) {
                DatePicker("", selection: $medicationLog.date)
                    .accessibilityLabel(Text("Entry Date"))
                    .padding(.bottom, min(scrollOffset.y*1.5, 40)-40)
                    .padding(.leading, -12)
                    .opacity(1-toolbarOpacity)
            }
            
            ToolbarItemGroup(placement: .principal) {
                Text("Create Entry")
                    .bold()
                    .opacity(toolbarOpacity)
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

private struct MedicationTakingDualCellLayout: View {
    let medication1: Medication
    let medication2: Medication?
    let isTakingMedicationBinding: (_ for: Medication) -> Binding<Bool>
    
    var body: some View {
        ViewThatFits {
            VStack {
                internalContent
            }
            HStack(alignment: .top) {
                internalContent
            }
        }
    }
    
    @ViewBuilder
    var internalContent: some View {
        MedicationTakingCellView(medication: medication1, isTakingMedication: isTakingMedicationBinding(medication1))
        if let medication2 {
            MedicationTakingCellView(medication: medication2, isTakingMedication: isTakingMedicationBinding(medication2))
        }
    }
}

private struct MedicationTakingCellView: View {
    let medication: Medication
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
