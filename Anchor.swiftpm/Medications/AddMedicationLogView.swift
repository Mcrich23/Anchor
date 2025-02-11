//
//  AddMedicationLogView.swift
//  Anchor
//
//  Created by Morris Richman on 2/5/25.
//

import SwiftUI
import SwiftData

struct AddMedicationLogView: View {
    let showManageMedicationButton: Bool
    let showAddMedicationButton: Bool
    @FocusState var isEditingMedicationLog
    @Bindable var medicationLog: MedicationLog
    var modelContext: ModelContext
    
    init(showManageMedicationButton: Bool = false, showAddMedicationButton: Bool = true, isEditingMedicationLog: FocusState<Bool> = FocusState(), medicationLog: MedicationLog, in context: ModelContext) {
        self.showManageMedicationButton = showManageMedicationButton
        self.showAddMedicationButton = showAddMedicationButton
        self._isEditingMedicationLog = isEditingMedicationLog
        
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
    @State var isShowingMedManager = false
    @State var scrollOffset: CGFloat = 0
    @State var startingOffset: CGFloat = 0
    var toolbarOpacity: CGFloat {
        let threshold: CGFloat = startingOffset+45
        
        guard scrollOffset > threshold else { return 0 }
        
        return min(((scrollOffset-threshold)/30), 1)
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
    
    var medications: [MedicationLogMedArrayElement] {
        medicationLog.medications.sorted(by: { $0.medication.name < $1.medication.name })
    }
    
    @ViewBuilder
    func toolbarTitle(scrollProxy: ScrollViewProxy) -> some View {
        Text("Create Entry")
            .bold()
            .opacity(toolbarOpacity)
            .background {
                toolbarScrollToTop(scrollProxy: scrollProxy)
            }
    }
    
    @ViewBuilder
    func toolbarScrollToTop(scrollProxy: ScrollViewProxy) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.bouncy) {
                    scrollProxy.scrollTo("Main VStack", anchor: .top)
                }
            }
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollViewReader { proxy in
        ScrollView {
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
                                    .buttonStyle(.reactiveBorderedProminent)
                                }
                            }
                        } else {
                            if geo.size.width < 500 {
                                VStack {
                                    ForEach(medications) { medicationLogElement in
                                        MedicationTakingCellView(medicationLogElement: medicationLogElement)
                                            .id(medicationLogElement.id)
                                    }
                                }
                            } else {
                                VStack {
                                    ForEach(halfMedicationsCount, id: \.self) { i in
                                        if i < medications.count-1 {
                                            MedicationTakingDualCellLayout(medication1: medications[i], medication2: medications[i+1])
                                        } else {
                                            MedicationTakingDualCellLayout(medication1: medications[i], medication2: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    .id("Main VStack")
                }
        .onScrollGeometryChange(for: CGFloat.self, of: { geo in
            geo.contentOffset.y
        }, action: { _, newValue in
            if self.startingOffset == 0 {
                self.startingOffset = newValue
            }
            self.scrollOffset = newValue
        })
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        ZStack {
                            DatePicker("", selection: $medicationLog.date)
                                .accessibilityLabel(Text("Entry Date"))
                                .offset(y: max(0, 20+(startingOffset-scrollOffset)))
                                .padding(.leading, -12)
                                .opacity(1-toolbarOpacity)
                            
                            if geo.size.width < 500 {
                                toolbarTitle(scrollProxy: proxy)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else if toolbarOpacity == 1 {
                                toolbarScrollToTop(scrollProxy: proxy)
                            }
                        }
                    }
                    
                    ToolbarItemGroup(placement: .principal) {
                        if geo.size.width > 500 {
                            toolbarTitle(scrollProxy: proxy)
                        } else {
                            toolbarScrollToTop(scrollProxy: proxy)
                        }
                    }
                    
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        toolbarScrollToTop(scrollProxy: proxy)
                        if showManageMedicationButton {
                            Button {
                                self.isShowingMedManager = true
                            } label: {
                                Label("Manage Medications", systemImage: "gear.circle")
                            }
                            .buttonStyle(.reactive)
                        }
                        
                        if showAddMedicationButton {
                            Button {
                                let medication = Medication.blank
                                self.creatingMedication = medication
                            } label: {
                                Label("Create Medication", systemImage: "plus.circle")
                            }
                            .buttonStyle(.reactive)
                        }
                            
                        Button {
                            cancel()
                        } label: {
                            Label("Cancel", systemImage: "xmark.circle")
                        }
                        .buttonStyle(.reactive)
                    }
                }
                .sheet(isPresented: $isShowingMedManager, content: {
                    NavigationStack {
                        MedicationManagementView()
                    }
                })
                .sheet(item: $creatingMedication) { item in
                    NavigationStack {
                        CreateMedicationView(medication: item, in: modelContext)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom, content: {
            VStack {
                TextField("Write how you feel...", text: medicationLog.notesBinding, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 4)
                    .focused($isEditingMedicationLog)
                
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
                .buttonStyle(.reactiveBorderedProminent)
                .background(Color(uiColor: .secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .disabled(medicationLog.takenMedications.isEmpty && medicationLog.notes?.isEmpty != false)
            }
            .padding()
            .background(.ultraThinMaterial)
        })
        .onChange(of: queriedMedications, initial: true, { _, newValue in
            for medication in newValue where !medicationLog.medications.contains(where: { $0.medication.underlyingMedication?.persistentModelID == medication.persistentModelID }) {
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
    let medication1: MedicationLogMedArrayElement
    let medication2: MedicationLogMedArrayElement?

    var body: some View {
//        ViewThatFits(in: .horizontal) {
//            VStack {
//                internalContent
//            }
            
            HStack(alignment: .top) {
                internalContent
            }
//        }
    }
    
    @ViewBuilder
    var internalContent: some View {
        MedicationTakingCellView(medicationLogElement: medication1)
        if let medication2 {
            MedicationTakingCellView(medicationLogElement: medication2)
        }
    }
}

private struct MedicationTakingCellView: View {
    @Bindable var medicationLogElement: MedicationLogMedArrayElement
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userResponseController: UserResponseController
    
    @ViewBuilder
    var buttonLabel: some View {
        switch medicationLogElement.isTaken {
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
            medicationLogElement.isTaken.toggle()
        } label: {
            Group {
                if colorScheme == .dark && medicationLogElement.isTaken {
                    buttonLabel
                        .colorInvert()
                } else {
                    buttonLabel
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.reactive)
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                HStack {
                    Text(medicationLogElement.medication.underlyingMedication?.name ?? medicationLogElement.medication.name)
                    
                    Text(medicationLogElement.medication.dosage)
                        .padding(.vertical, 3)
                        .padding(.horizontal)
                        .background(Color.dynamicColor(light: .tertiarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Spacer()
                    
                    Picker("Quantity", selection: $medicationLogElement.medication.quantity) {
                        ForEach(1..<100) { i in
                            Text("\(i)")
                                .tag(i)
                        }
                    }
                    .onChange(of: medicationLogElement.medication.quantity) { _, _ in
                        medicationLogElement.isTaken = true
                    }
                }
                if !medicationLogElement.medication.notes.isEmpty {
                    Divider()
                    Text(medicationLogElement.medication.notes)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Divider()
                switch medicationLogElement.isTaken {
                    case true:
                    button
                        .buttonStyle(.secondaryReactiveBorderedProminent)
                case false:
                    button
                        .buttonStyle(.secondaryReactiveBordered)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
