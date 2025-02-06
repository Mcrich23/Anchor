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
    @Environment(\.colorScheme) var colorScheme
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
    
    @ViewBuilder
    var toolbarTitle: some View {
        Text("Create Entry")
            .bold()
            .opacity(toolbarOpacity)
    }
    
    var body: some View {
        GeometryReader { geo in
            OffsetObservingScrollView(offset: $scrollOffset) {
                VStack {
                    Text("Create Entry")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if geo.size.width < 500 {
                        VStack {
                            ForEach(medications) { medication in
                                MedicationTakingCellView(medication: medication, isTakingMedication: isTakingMedicationBinding(for: medication))
                            }
                        }
                    } else {
                        VStack {
                            ForEach(0..<halfMedicationsCount, id: \.self) { i in
                                if i < medications.count-1 {
                                    MedicationTakingDualCellLayout(medication1: medications[i], medication2: medications[i+1], isTakingMedicationBinding: isTakingMedicationBinding)
                                } else {
                                    MedicationTakingDualCellLayout(medication1: medications[i], medication2: nil, isTakingMedicationBinding: isTakingMedicationBinding)
                                }
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
                        Group {
                            if colorScheme == .dark && !medicationLog.medications.isEmpty {
                                Text("Done")
                                    .colorInvert()
                            } else {
                                Text("Done")
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(medicationLog.medications.isEmpty)
                }
                .padding()
                .background(.ultraThinMaterial)
            })
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    ZStack {
                        DatePicker("", selection: $medicationLog.date)
                            .accessibilityLabel(Text("Entry Date"))
                            .offset(y: 20-min(scrollOffset.y, 20))
                            .padding(.leading, -12)
                            .opacity(1-toolbarOpacity)
                        
                        if geo.size.width < 500 {
                            toolbarTitle
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
                if geo.size.width > 500 {
                    ToolbarItemGroup(placement: .principal) {
                        toolbarTitle
                    }
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
}

private struct MedicationTakingDualCellLayout: View {
    let medication1: Medication
    let medication2: Medication?
    let isTakingMedicationBinding: (_ for: Medication) -> Binding<Bool>
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
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
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    var buttonLabel: some View {
        switch isTakingMedication {
        case true:
            Label("Taken", systemImage: "checkmark.circle")
                .labelStyle(.titleAndIcon)
        case false:
            Label("Taken", systemImage: "checkmark.circle")
                .labelStyle(.titleOnly)
        }
    }
    
    @ViewBuilder
    var button: some View {
        Button {
            isTakingMedication.toggle()
        } label: {
            Group {
                if colorScheme == .dark && isTakingMedication {
                    buttonLabel
                        .colorInvert()
                } else {
                    buttonLabel
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
                        .background(Color.dynamicColor(light: .tertiarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
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
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
