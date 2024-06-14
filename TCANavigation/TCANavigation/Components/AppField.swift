//
//  AppField.swift
//  TCANavigation
//
//  Created by iSHIKA on 01/06/24.
//

import SwiftUI

struct AppField: View {
    var placeHolder: String = ""
    @Binding var text: String
    var isSecure: Bool = false
    var body: some View {
        VStack {
            if isSecure {
                SecureField(placeHolder, text: $text)
            } else {
                TextField(placeHolder, text: $text)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.blue)
                .frame(height: 50)
        )
    }
}

#Preview {
    AppField(text: .constant("hello"))
        .padding()
}

