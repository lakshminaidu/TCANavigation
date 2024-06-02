//
//  LoginView.swift
//  TCANavigation
//
//  Created by iSHIKA on 31/05/24.
//

import SwiftUI
import ComposableArchitecture

struct LoginView: View {
    @State var store: StoreOf<LoginReducer>
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            content
        } destination: { state in
            switch state.case {
            case .forgotPassword(let store):
                ForgotPasswordView(store: store)
            case .signup(let store):
                SignupView(store: store)
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 16) {
            Text("Welcome")
                .frame(height: 40)
                .frame(maxWidth: .infinity)
            
            AppField(placeHolder: "Enter username", text: $store.username)
            AppField(placeHolder: "Enter password", text: $store.password, isSecure: true)

            if !store.isValid {
                Text(store.validationError)
                    .foregroundStyle(.red)
            }
            HStack {
                Spacer()
                Text("Forgot password")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        self.store.send(.showForgoPassword)
                    }
            }
            AppButton(action: { store.send(.login) }, title: "Login")
            Text("Or")
                .foregroundStyle(.secondary)
                .font(.footnote)
            AppButton(action: { store.send(.showSignup) }, title: "Signup")
        }
        .padding()
    }
}

#Preview {
    LoginView(store: Store(initialState: LoginReducer.State(), reducer: {
        LoginReducer()
    }))
}


@Reducer
struct LoginReducer {
    @ObservableState
    struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var validationError: String = ""
        var isValid: Bool = true
        var path = StackState<Destination.State>()
    }
    
    enum Action: BindableAction {
        case login
        case showHome
        case showForgoPassword
        case showSignup
        case binding(BindingAction<State>) // binding state values
        case path(StackAction<Destination.State, Destination.Action>) // navigation
    }
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .login:
                if state.username.isEmpty {
                    state.isValid = false
                    state.validationError = "Please enter username"
                } else if state.password.isEmpty {
                    state.isValid = false
                    state.validationError = "Please enter password"
                    
                } else {
                    return .run { send in
                        await send(.showHome)
                    }
                }
                return .none
            case .binding(\.username):
                // username observing here
                state.isValid = true
                state.validationError = ""
                print("username", state.username)
                return .none
            case .binding(\.password):
                // password observing here
                state.isValid = true
                state.validationError = ""
                print("Password", state.password)
                return .none
            case .showForgoPassword:
                // Navigation start here
                state.path.append(.forgotPassword(ForgotPasswordReducer.State(password: "password", confirmPassword: "password")))
                return .none
            case .showSignup:
                // Navigation start here
                state.path.append(.signup(SignupReducer.State(username: "Demo", password: "password", confirmPassword: "password")))
                return .none
            case .binding(_):
                return .none
            case .showHome:
                state.path.removeAll()
                return .none
            case .path(.element(id: _, action: let action)):
                switch action {
                case .signup(\.showHome):
                    return .run { send in
                        await send(.showHome)
                    }
                case .signup(\.showLogin),
                     .forgotPassword(\.showLogin):
                    state.path.removeAll()
                default: break
                }
                return .none
            case .path(.popFrom(id: _)):
                state.path.removeAll()
            case .path(_):
                return .none
            }
            return .none
        }
        .forEach(\.path, action: \.path)
    }
    
    @Reducer(state: .equatable)
    enum Destination {
        case forgotPassword(ForgotPasswordReducer)
        case signup(SignupReducer)
    }
}
