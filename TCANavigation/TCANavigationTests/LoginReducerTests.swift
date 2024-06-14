//
//  LoginReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

final class LoginReducerTests: XCTestCase {
    @MainActor
    func test_Login_withEmptyUsernameAndPassword() async {
        let store = TestStore(initialState: LoginReducer.State()) {
            LoginReducer()
        }
        await store.send(.login) {
            $0.validationError = "Please enter username"
            $0.isValid = false
        }
    }
    
    @MainActor
    func test_Login_withEmptyPassword() async {
        let store = TestStore(initialState: LoginReducer.State(username: "Test")) {
            LoginReducer()
        }
        await store.send(.login) {
            $0.validationError = "Please enter password"
            $0.isValid = false
        }
    }
    
    @MainActor
    func test_Login_success() async {
        let store = TestStore(initialState: LoginReducer.State(username: "Test", password: "password")) {
            LoginReducer()
        }
        await store.send(.login)
        await store.receive(\.showHome) 
    }
    
    @MainActor
    func test_signup_navigation() async {
        let store = TestStore(initialState: LoginReducer.State()) {
            LoginReducer()
        }
        // show signup
        await store.send(.showSignup) {
            $0.path[id: 0] = .signup(SignupReducer.State(username: "Demo", password: "password", confirmPassword: "password"))
        }
    }
    
    @MainActor
    func test_forgotPassword_navigation() async {
        let store = TestStore(initialState: LoginReducer.State()) {
            LoginReducer()
        } withDependencies: {
            $0.apiClient = .testValue
        }
        // show forgotPassword
        await store.send(.showForgoPassword) {
            $0.path[id: 0] = .forgotPassword(ForgotPasswordReducer.State(password: "password", confirmPassword: "password"))
        }
    }
}
