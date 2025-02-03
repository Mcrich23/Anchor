//
//  CreateMedicationView.swift
//  Anchor
//
//  Created by Morris Richman on 2/2/25.
//

import SwiftUI

private enum CreateMedicationViewSteps: Int, ViewSteps {
    case name
    case dosage
    case instructions
}

struct CreateMedicationView: View {
    @Bindable var medication: Medication
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: "pill.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 150, maxHeight: 150)
                .symbolRenderingMode(.multicolor)
                .foregroundStyle(.pink)
            
            TextField("Name", text: $medication.name)
                .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var medication = Medication(name: "", dosage: "")
    
    CreateMedicationView(medication: medication)
}
