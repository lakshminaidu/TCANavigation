//
//  DetailReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

final class DetailReducerTests: XCTestCase {
    @MainActor
    func test_logout() async {
		let store = TestStore(initialState: DetailReducer.State()) {
			DetailReducer()
		}
		await store.send(.logout)
	}

    @MainActor
	func test_fetchTodos() async {
		let store = TestStore(initialState: DetailReducer.State()) {
			DetailReducer()
		} withDependencies: {
			$0.apiClient.fetchTodos = { url in
				return TodoItem.mocks
			}
		}
		await store.send(.fetchdData) {
			$0.isLoading = true
		}
		await store.receive(\.processResponse) {
			$0.isLoading = false
			$0.todos = TodoItem.mocks
		}

	}
}
