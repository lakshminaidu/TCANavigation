//
//  SignupReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

final class SignupReducerTests: XCTestCase {
    @MainActor
	func test_signup_withEmptyUsernameAndPassword() async {
		let store = TestStore(initialState: SignupReducer.State()) {
			SignupReducer()
		}
		await store.send(.signup) {
			$0.validationError = "Please enter username"
			$0.isValid = false
		}
	}

    @MainActor
	func test_signup_withEmptyPassword() async {
		let store = TestStore(initialState: SignupReducer.State(username: "Test")) {
			SignupReducer()
		}
		await store.send(.signup) {
			$0.validationError = "Please enter password"
			$0.isValid = false
		}
	}

    @MainActor
	func test_signup_with_diffrentPasswords() async {
		let store = TestStore(initialState: SignupReducer.State(username: "Test", password: "demo", confirmPassword: "demo1")) {
			SignupReducer()
		}
		await store.send(.signup) {
			$0.validationError = "Passwords are not matching"
			$0.isValid = false
		}
	}

    @MainActor
	func test_Login_success() async {
		let store = TestStore(initialState: SignupReducer.State(username: "Test", password: "password", confirmPassword: "password")) {
			SignupReducer()
		}
		await store.send(.signup)
		await store.receive(\.showHome) {
			$0.isValid = true
			$0.validationError = ""
		}
	}
}
