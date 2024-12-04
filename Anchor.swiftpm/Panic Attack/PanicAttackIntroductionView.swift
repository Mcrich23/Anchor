//
//  PanicAttackIntroductionView.swift
//  Anchor
//
//  Created by Morris Richman on 12/4/24.
//

import SwiftUI

struct PanicAttackIntroductionView: View {
    @Environment(\.customDismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("You will be alright")
            Button("Back", action: dismiss)
        }
    }
}

#Preview {
    PanicAttackIntroductionView()
}
