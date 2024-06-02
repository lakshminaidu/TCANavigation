//
//  AppButton.swift
//  TCANavigation
//
//  Created by iSHIKA on 01/06/24.
//

import SwiftUI

struct AppButton: View {
    var action: (() -> Void) = {  }
    var title: String = ""
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
}

#Preview {
    AppButton(action: {
        
    })
}
