//
//  RootReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

@MainActor
final class AppRootReducerTests: XCTestCase {

    func test_login_success() async {
        let store = TestStore(initialState: AppRootReducer.State(login: LoginReducer.State(username: "Test", password: "Test"), isLoggedIn: false)) {
            AppRootReducer()
        }
        await store.send(.login(.login))
        await store.receive(\.login.showHome) {
            $0.isLoggedIn = true
        }
    }
    
    func test_login_validation() async {
        let store = TestStore(initialState: AppRootReducer.State(isLoggedIn: false)) {
            AppRootReducer()
        }
        await store.send(.login(.login)) {
            $0.login.isValid = false
            $0.login.validationError = "Please enter username"
        }
    }
    
    func test_logout() async {
        let store = TestStore(initialState: AppRootReducer.State(isLoggedIn: true)) {
            AppRootReducer()
        }
        await store.send(.home(.logout)) {
            $0.isLoggedIn = false
        }
    }
    
    func test_signup_navigation_Login() async {
        let store = TestStore(initialState: AppRootReducer.State(isLoggedIn: false)) {
            AppRootReducer()
        }
        await store.send(.login(.showSignup)) {
            $0.login.path[id: 0] = .signup(SignupReducer.State(username: "Demo", password: "password", confirmPassword: "password"))
        }
        await store.send(\.login.path[id: 0].signup.showLogin) {
            $0.login.path[id: 0] = nil
        }
    }
    
    func test_signup_navigation_Home() async {
        let store = TestStore(initialState: AppRootReducer.State(isLoggedIn: false)) {
            AppRootReducer()
        }
        // show signup
        await store.send(.login(.showSignup)) {
            $0.login.path[id: 0] = .signup(SignupReducer.State(username: "Demo", password: "password", confirmPassword: "password"))
        }
        // click signup
        await store.send(\.login.path[id: 0].signup.showHome) {
            $0.isLoggedIn = false
            $0.login.path[id: 0]?.signup?.isValid = true
        }
        // signup is valid success
        await store.receive(\.login.showHome) {
            $0.login.path[id: 0] = nil
            $0.isLoggedIn = true
        }
        
    }
}
