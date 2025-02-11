//
//  CreateMedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

private enum CreateMedicationViewSteps: Int, ViewSteps {
    case name
    case dosage
}

@Observable
private final class CreateMedStepManager {
    private(set) var step: CreateMedicationViewSteps = .name
    var isBack = false
    
    func next() {
        isBack = false
        withAnimation {
            step.next()
        }
    }
    func previous() {
        isBack = true
        withAnimation {
            step.previous()
        }
    }
}

struct CreateMedicationView: View {
    @State private var stepManager = CreateMedStepManager()
    @Bindable var medication: Medication
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userResponseController: UserResponseController
    var modelContext: ModelContext
    
    init(medication: Medication, in context: ModelContext) {
        let registeredModel: Medication? = context.registeredModel(for: medication.id)
        
        guard registeredModel != nil else {
            self.medication = medication
            self.modelContext = context
            return
        }
        
        modelContext = ModelContext(context.container)
        modelContext.autosaveEnabled = false
        
        self.medication = modelContext.model(for: medication.id) as? Medication ?? medication
    }
    
    var body: some View {
        VStack {
            Image("custom.pill.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 100)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(Color.medPillBlue, Color.medPillGreen)
            
            Text("Add Medication")
                .font(.largeTitle)
                .bold()
            GroupBox {
                TextField("Name", text: $medication.name)
            }
            GroupBox {
                TextEditor(text: $medication.notes)
                    .scrollContentBackground(.hidden)
                    .overlay(alignment: .topLeading) {
                        if medication.notes.isEmpty {
                            Text("Notes (Optional)")
                                .foregroundStyle(.tertiary)
                                .padding(.leading, 5)
                                .padding(.top, 8.5)
                        }
                    }
                    .padding(-5)
            }
            
            Spacer()
            
            NavigationLink {
                CreateMedicationDosageView(dismissSheet: dismiss, medication: medication)
            } label: {
                Group {
                    if medication.name.isEmpty {
                        Text("Continue")
                    } else {
                        Text("Continue")
                            .foregroundStyle(Color.primary)
                            .colorInvert()
                    }
                }
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.reactiveBorderedProminent)
            .disabled(medication.name.isEmpty)
        }
        .environment(\.modelContext, modelContext)
        .padding()
        .toolbar(content: {
            Button("Cancel") {
                dismiss()
            }
            .buttonStyle(.secondaryReactive)
        })
    }
}

private enum CreateMedicationDosageUnit: String, CaseIterable {
    case mg
    case mcg
    case g
    case mL
    case percent = "%"
}

private struct CreateMedicationDosageView: View {
    let dismissSheet: DismissAction
    @Bindable var medication: Medication
    @State private var unit = CreateMedicationDosageUnit.mg
    @State private var dosage = ""
    @Environment(\.modelContext) private var modelContext
    @Query var medicationLogs: [MedicationLog] = []
    
    var medicationQuantity: Binding<Int> {
        Binding {
            medication.quantity ?? 1
        } set: { newValue in
            medication.quantity = newValue
        }

    }
    
    var body: some View {
        VStack {
            DosageMedicationIcon()
                .frame(maxWidth: 100, maxHeight: 100)
                .rotationEffect(.degrees(45))
//                .scaleEffect(2)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Add Dosage")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    GroupBox {
                        HStack {
                            TextField("Dosage", text: $dosage)
                                .keyboardType(.numbersAndPunctuation)
                            
                            Picker("Quantity", selection: medicationQuantity) {
                                ForEach(1..<100) { i in
                                    Text("\(i)")
                                        .tag(i)
                                }
                            }
                        }
                    }
                }
                VStack {
                    Text("Choose Unit")
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    GroupBox {
                        VStack {
                            ForEach(CreateMedicationDosageUnit.allCases, id: \.self) { unit in
                                Button {
                                    withAnimation {
                                        self.unit = unit
                                    }
                                } label: {
                                    HStack {
                                        Text(unit.rawValue)
                                        
                                        Spacer()
                                        
                                        if self.unit == unit {
                                            Image(systemName: "checkmark")
                                                .foregroundStyle(.tint)
                                        }
                                    }
                                    .foregroundStyle(Color.primary)
                                }
                                .buttonStyle(.reactive)
                                if unit != CreateMedicationDosageUnit.allCases.last {
                                    Divider()
                                }
                            }
                        }
                    }
                }
                
                Button {
                    if !medicationLogs.contains(where: { $0.persistentModelID == medication.persistentModelID }) {
                        guard !medication.dosage.isEmpty else { return }
                        modelContext.insert(medication)
                    }
                    try? modelContext.save()
                    dismissSheet()
                } label: {
                    Group {
                        if dosage.isEmpty {
                            Text("Done")
                        } else {
                            Text("Done")
                                .foregroundStyle(Color.primary)
                                .colorInvert()
                        }
                    }
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.reactiveBorderedProminent)
                .disabled(dosage.isEmpty)
            }
        }
        .toolbar(content: {
            Button("Cancel") {
                dismissSheet()
            }
            .buttonStyle(.secondaryReactive)
        })
        .navigationTitle(medication.name)
        .onChange(of: dosage) { _, newValue in
            self.medication.dosage = newValue + unit.rawValue
        }
        .onChange(of: unit) { _, newValue in
            self.medication.dosage = dosage + newValue.rawValue
        }
        .onAppear(perform: {
            var dosage = medication.dosage
            
            for unit in CreateMedicationDosageUnit.allCases {
                if dosage.hasSuffix(unit.rawValue) {
                    self.unit = unit
                    dosage = dosage.replacingOccurrences(of: unit.rawValue, with: "")
                }
            }
            
            self.dosage = dosage
        })
        .padding()
    }
}

#Preview {
    @Previewable @State var medication = Medication.blank
    @Previewable @Environment(\.modelContext) var modelContext
    
    NavigationStack {
        CreateMedicationView(medication: medication, in: modelContext)
    }
}
