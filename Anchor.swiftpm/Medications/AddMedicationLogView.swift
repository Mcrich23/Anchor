//
//  AddMedicationLogView.swift
//  Anchor
//
//  Created by Morris Richman on 2/5/25.
//

import SwiftUI
import SwiftData

struct AddMedicationLogView: View {
    @Bindable var medicationLog: MedicationLog
    var modelContext: ModelContext
    
    init(medicationLog: MedicationLog, in context: ModelContext) {
        let registeredModel: MedicationLog? = context.registeredModel(for: medicationLog.id)
        
        guard registeredModel != nil else {
            self.medicationLog = medicationLog
            self.modelContext = context
            return
        }
        
        modelContext = ModelContext(context.container)
        modelContext.autosaveEnabled = false
        
        self.medicationLog = modelContext.model(for: medicationLog.id) as? MedicationLog ?? medicationLog
    }
    
    @Query(sort: \Medication.name) var queriedMedications: [Medication] = []
    @Query var medicationLogs: [MedicationLog] = []
    @Environment(\.dismiss) var dismiss
    @Environment(\.customDismiss) var customDismiss
    @Environment(\.colorScheme) var colorScheme
    @State var creatingMedication: Medication?
    @State var scrollOffset: CGPoint = .zero
    var toolbarOpacity: CGFloat {
        let threshold: CGFloat = 30
        
        guard scrollOffset.y > threshold else { return 0 }
        
        return min(((scrollOffset.y-threshold)/30), 1)
    }
    
    func isTakingMedicationBinding(for medication: MedicationLogMed) -> Binding<Bool> {
        Binding {
            guard let index = medicationLog.medications.firstIndex(where: { $0.medication == medication }) else { return false }
            
            return medicationLog.medications[index].isTaken
        } set: { isTaking in
            if !medicationLog.medications.contains(where: { $0.medication == medication }) {
                medicationLog.medications.append(.init(isTaken: isTaking, medication: medication))
            }
            
            guard let index = medicationLog.medications.firstIndex(where: { $0.medication == medication }) else { return }
            medicationLog.medications[index].isTaken = isTaking
        }
    }
    
    func medicationQuantityBinding(for medication: MedicationLogMed) -> Binding<Int> {
        Binding {
            medication.quantity
        } set: { newValue in
            medication.quantity = newValue
        }
    }
    
    var halfMedicationsCount: [Int] {
        let upperBound = (Double(medications.count)/2).rounded(.up)
        
        let array = (0..<Int(upperBound)).map { i in
            i*2
        }
        
        return array
    }
    
    var medications: [MedicationLogMed] {
        medicationLog.medications.compactMap(\.medication).sorted(by: { $0.name < $1.name })
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
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    } else {
                        if geo.size.width < 500 {
                            VStack {
                                ForEach(medications) { medication in
                                    MedicationTakingCellView(medication: medication, medicationQuantity: medicationQuantityBinding(for: medication), isTakingMedication: isTakingMedicationBinding(for: medication))
                                }
                            }
                        } else {
                            VStack {
                                ForEach(halfMedicationsCount, id: \.self) { i in
                                    if i < medications.count-1 {
                                        MedicationTakingDualCellLayout(medication1: medications[i], medication2: medications[i+1], medicationQuantityBinding: medicationQuantityBinding, isTakingMedicationBinding: isTakingMedicationBinding)
                                    } else {
                                        MedicationTakingDualCellLayout(medication1: medications[i], medication2: nil, medicationQuantityBinding: medicationQuantityBinding, isTakingMedicationBinding: isTakingMedicationBinding)
                                    }
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
                        done()
                    } label: {
                        Group {
                            if colorScheme == .dark && !medicationLog.takenMedications.isEmpty {
                                Text("Done")
                                    .colorInvert()
                            } else {
                                Text("Done")
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(medicationLog.takenMedications.isEmpty)
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
                        let medication = Medication.blank
                        self.creatingMedication = medication
                    } label: {
                        Label("Create Medication", systemImage: "plus.circle")
                    }
                    Button {
                        cancel()
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle")
                    }
                }
            }
            .sheet(item: $creatingMedication) { item in
                NavigationStack {
                    CreateMedicationView(medication: item, in: modelContext)
                }
            }
        }
        .onChange(of: queriedMedications, initial: true, { _, newValue in
            for medication in newValue where !medicationLog.medications.contains(where: { $0.medication.underlyingMedication?.id == medication.id }) {
                let med = MedicationLogMed(from: medication)
                medicationLog.medications.append(MedicationLogMedArrayElement(isTaken: false, medication: med))
                try? modelContext.save()
            }
        })
    }
    
    func done() {
        if !medicationLogs.contains(where: { $0.persistentModelID == medicationLog.persistentModelID }) {
            modelContext.insert(medicationLog)
        }
        try? modelContext.save()
        
        dismiss()
        customDismiss()
    }
    
    func cancel() {
        dismiss()
        customDismiss()
    }
}

private struct MedicationTakingDualCellLayout: View {
    let medication1: MedicationLogMed
    let medication2: MedicationLogMed?
    let medicationQuantityBinding: (_ for: MedicationLogMed) -> Binding<Int>
    let isTakingMedicationBinding: (_ for: MedicationLogMed) -> Binding<Bool>
    
    var body: some View {
        ViewThatFits(in: .horizontal) {
//            VStack {
//                internalContent
//            }
            
            HStack(alignment: .top) {
                internalContent
            }
        }
    }
    
    @ViewBuilder
    var internalContent: some View {
        MedicationTakingCellView(medication: medication1, medicationQuantity: medicationQuantityBinding(medication1), isTakingMedication: isTakingMedicationBinding(medication1))
        if let medication2 {
            MedicationTakingCellView(medication: medication2, medicationQuantity: medicationQuantityBinding(medication2), isTakingMedication: isTakingMedicationBinding(medication2))
        }
    }
}

private struct MedicationTakingCellView: View {
    let medication: MedicationLogMed
    @Binding var medicationQuantity: Int
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
                    Text(medication.underlyingMedication?.name ?? medication.name)
                    Spacer()
                    
                    Picker("Quantity", selection: $medicationQuantity) {
                        ForEach(1..<100) { i in
                            Text("\(i)")
                                .tag(i)
                        }
                    }
                    .onChange(of: medicationQuantity) { _, _ in
                        isTakingMedication = true
                    }
                }
                if !medication.notes.isEmpty {
                    Divider()
                    Text(medication.notes)
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
