//
//  ForgotPasswordReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

final class ForgotPasswordReducerTests: XCTestCase {
    @MainActor
	func test_updatePassword_success() async {
		let store = TestStore(initialState: ForgotPasswordReducer.State(password: "hello", confirmPassword: "hello")) {
			ForgotPasswordReducer()
		}
		await store.send(.updatePassword)
		await store.receive(\.showLogin)
	}
}
