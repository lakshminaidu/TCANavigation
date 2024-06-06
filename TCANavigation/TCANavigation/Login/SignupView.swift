//
//  SignupView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct SignupView: View {
    @Bindable var store: StoreOf<SignupReducer>
    var body: some View {
        VStack {
            Text("Welcome")
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            AppField(placeHolder: "Enter username", text: $store.username)
            AppField(placeHolder: "Enter password", text: $store.password, isSecure: true)
            AppField(placeHolder: "Re type password", text: $store.confirmPassword, isSecure: true)
            if !store.isValid {
                Text(store.validationError)
                    .foregroundStyle(.red)
            }
            AppButton(action: {
                store.send(.signup)
            }, title: "Signup")
            AppButton(action: {
                store.send(.showLogin)
            }, title: "Login")
        }
        .padding()
        .navigationTitle("Signup")
    }
}

#Preview {
    SignupView(store: Store(initialState: SignupReducer.State(), reducer: {
        SignupReducer()
    }))
}


@Reducer
struct SignupReducer {
    @ObservableState
    struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var validationError: String = ""
        var isValid: Bool = false
    }
    
    enum Action: BindableAction {
        case signup
        case showLogin
        case showHome
        case binding(BindingAction<State>)
    }
    var body: some ReducerOf<Self> {
        BindingReducer()
		Reduce { state, action in
			switch action {
			case .signup:
				if state.username.isEmpty {
					state.isValid = false
					state.validationError = "Please enter username"
					return .none
				} else if state.password.isEmpty || state.confirmPassword.isEmpty {
					state.isValid = false
					state.validationError = "Please enter password"
					return .none
				} else if state.password != state.confirmPassword {
					state.isValid = false
					state.validationError = "Passwords are not matching"
					return .none
				} else {
					return .run { send in
						await send(.showHome)
					}
				}
			case .showLogin:
				return .none
			case .showHome:
				state.isValid = true
				state.validationError = ""
				return .none
			case .binding(_):
				state.isValid = true
				state.validationError = ""
				return .none
			case .binding(\.username):
				// username observing here
				print("username", state.username)
				return .none
			case .binding(\.password):
				// username observing here
				print("password", state.password)
				return .none
			case .binding(\.confirmPassword):
				// username observing here
				print("password", state.confirmPassword)
				return .none
			}
		}
    }
}
