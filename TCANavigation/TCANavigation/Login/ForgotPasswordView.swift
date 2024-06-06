//
//  ForgotPasswordView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct ForgotPasswordView: View {
    @Bindable var store: StoreOf<ForgotPasswordReducer>
    var body: some View {
        VStack(spacing: 16) {
           Text("Welcome")
            AppField(placeHolder: "Enter password", text: $store.password, isSecure: true)
            AppField(placeHolder: "Confirm password", text: $store.confirmPassword, isSecure: true)
            AppButton(action: { store.send(.updatePassword) }, title: "Update")
        }
        .padding()
        .navigationTitle("Forgot Password")
    }
}

#Preview {
    ForgotPasswordView(store: Store(initialState: ForgotPasswordReducer.State(), reducer: {
        ForgotPasswordReducer()
    }))
}


@Reducer
struct ForgotPasswordReducer {
    @ObservableState
    struct State: Equatable {
        var password: String = ""
        var confirmPassword: String = ""
    }
    
    enum Action: BindableAction {
        case updatePassword
        case showLogin
        case binding(BindingAction<State>)
    }
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.password):
                // password observing here
                print("Password", state.password)
                return .none
            case .binding(\.confirmPassword):
                // password observing here
                print("ConfirmPassword", state.password)
                return .none
            case .binding(_):
                return .none
            case .updatePassword:
                return .run { send in
                    await send(.showLogin)
                }
            case .showLogin:
                return .none
            }
        }
    }
}
