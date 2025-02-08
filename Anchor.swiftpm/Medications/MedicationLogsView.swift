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
    @Query(filter: #Predicate<MedicationLog> { !$0.medications.isEmpty }, sort: \.date) var medicationLogs: [MedicationLog] = []
    @Environment(\.modelContext) var modelContext
    @Binding var isShowingAddMedicationLogView: MedicationLog?
    @Binding var isShowingMedManager: Bool
    
    var body: some View {
        List {
            ForEach(medicationLogs) { log in
                Section {
                    Button {
                        isShowingAddMedicationLogView = log
                    } label: {
                        LogEntryView(entry: log)
                    }
                    .foregroundStyle(.primary, .secondary, .tertiary)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let log = medicationLogs[index]
                    modelContext.delete(log)
                }
                
                try? modelContext.save()
            }
        }
        .navigationTitle("Medication Log")
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
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        })
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                EditButton()
                Button {
                    isShowingMedManager.toggle()
                } label: {
                    Label("Manage Medications", systemImage: "gear")
                        .labelStyle(.iconOnly)
                }
            }
            
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    let medicationLog = MedicationLog.blank
                    self.isShowingAddMedicationLogView = medicationLog
                } label: {
                    Label("Create Entry", systemImage: "plus.circle")
                }
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
            
            Text("\(medication.quantity)")
                .padding(.vertical, 3)
                .padding(.horizontal)
                .background(Color.dynamicColor(light: .tertiarySystemBackground, dark: .tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
        }
    }
}

#Preview {
    NavigationStack {
        MedicationLogsView()
    }
        .modelContainer(for: MedicationLog.self, isAutosaveEnabled: true)
}
