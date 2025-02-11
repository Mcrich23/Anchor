//
//  MedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI
import SwiftData

// Exists to Refresh Data when SwiftData is updated by subviews
struct MedicationLogsView: View {
    @State private var contextDidSaveDate = Date()
    @State var isShowingAddMedicationLogView: MedicationLog? = nil
    @State var isShowingMedManager = false
    
    var body: some View {
        MedicationLogsViewInternal(isShowingAddMedicationLogView: $isShowingAddMedicationLogView, isShowingMedManager: $isShowingMedManager)
            .id(contextDidSaveDate)
            .onReceive(NotificationCenter.default.managedObjectContextDidSavePublisher) { _ in
                guard !isShowingMedManager && isShowingAddMedicationLogView == nil else { return }
                
                contextDidSaveDate = .now
            }
    }
}

// Actual View
private struct MedicationLogsViewInternal: View {
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty || $0.notes != nil }, sort: \.date, order: .reverse) var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @Binding var isShowingAddMedicationLogView: MedicationLog?
    @Binding var isShowingMedManager: Bool
    @EnvironmentObject var userResponseController: UserResponseController
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section {
                    Button {
                        isShowingAddMedicationLogView = log
                    } label: {
                        LogEntryView(entry: log)
                    }
                    .buttonStyle(.reactive)
                    .foregroundStyle(.primary, .secondary, .tertiary)
                }
            }
            .onDelete { indexSet in
                userResponseController.playSoundEffect(.delete)
                for index in indexSet {
                    let log = medicationLogs[index]
                    modelContext.delete(log)
                }
                
                try? modelContext.save()
            }
        }
        .animation(.default, value: medicationLogs)
        .navigationTitle("Medication Log")
        .navigationBarTitleDisplayMode(.large)
        .toolbarTitleDisplayMode(.large)
        .overlay(content: {
            if medicationLogs.isEmpty {
                VStack {
                    ContentUnavailableView {
                        Text("No Entries")
                    } description: {
                        Text("You haven't added any entries yet.")
                    } actions: {
                        Button("Get Started") {
                            let medicationLog = MedicationLog.blank
                            self.isShowingAddMedicationLogView = medicationLog
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
                    .buttonStyle(.reactive)
                Button {
                    isShowingMedManager = true
                } label: {
                    Label("Manage Medications", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.reactive)
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    let medicationLog = MedicationLog.blank
                    self.isShowingAddMedicationLogView = medicationLog
                } label: {
                    Label("Create Entry", systemImage: "plus.circle")
                }
                .buttonStyle(.reactive)
            }
        }
        .sheet(isPresented: $isShowingMedManager, content: {
            NavigationStack {
                MedicationManagementView()
            }
        })
        .sheet(item: $isShowingAddMedicationLogView) { item in
            NavigationStack {
                AddMedicationLogView(medicationLog: item, in: modelContext)
                    .environment(\.customDismiss, {})
            }
        }
    }
}

private struct LogEntryView: View {
    let entry: MedicationLog
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.date.formatted(date: .abbreviated, time: .standard))
                .font(.headline)
                .fontDesign(.default)
            Divider()
            ForEach(entry.takenMedications) { medication in
                EntryLogMedicationView(medication: medication)
            }
            
            if let notes = entry.notes {
                if entry.takenMedications.isEmpty {
                    Text(notes)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    GroupBox {
                        Text(notes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
}

private struct EntryLogMedicationView: View {
    let medication: MedicationLogMed
    
    var body: some View {
        HStack {
            Image(systemName: "pill.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.pink)
            Text(medication.underlyingMedication?.name ?? medication.name)
            
            Text("\(medication.quantity) (\(medication.dosage))")
                .padding(.vertical, 3)
                .padding(.horizontal)
                .background(Color.dynamicColor(light: .secondarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
        }
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
