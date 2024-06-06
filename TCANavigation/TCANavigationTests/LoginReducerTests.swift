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
}
