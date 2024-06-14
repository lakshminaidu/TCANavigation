//
//  HomeReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation

final class HomeReducerTests: XCTestCase {
    @MainActor
    func test_profile_logout() async {
		let store = TestStore(initialState: HomeReducer.State()) {
			HomeReducer()
		}
		await store.send(.showProfile(1)) {
			$0.path[id: 0] = .profile(ProfileReducer.State(userid: 1))
		}
		await store.send(\.path[id: 0].profile.logout) {
			$0.path[id: 0] = nil
		}
        await store.receive(\.logout)
	}
    
    @MainActor
	func test_detail_logout() async {
		let store = TestStore(initialState: HomeReducer.State()) {
			HomeReducer()
		}
		await store.send(.showDetail(1)) {
			$0.path[id: 0] = .detail(DetailReducer.State(userid: 1))
		}
		await store.send(\.path[id: 0].detail.logout) {
			$0.path[id: 0] = nil
		}
        await store.receive(\.logout)
	}

    @MainActor
	func test_apicall_fetchData() async {
		let store = TestStore(initialState: HomeReducer.State()) {
			HomeReducer()
		} withDependencies: {
            $0.apiClient = .testValue
		}
		await store.send(.fetchdData) {
			$0.isLoading = true
			$0.posts = Post.mocks
		}
        await store.receive(\.processResponse) {
            $0.isLoading = false
            $0.posts = Post.mocks
        }
	}

    @MainActor
	func test_fetchPosts() async {
		let store = TestStore(initialState: HomeReducer.State()) {
			HomeReducer()
		} withDependencies: {
            $0.apiClient = .testValue
		}
		await store.send(.fetchdData) {
			$0.isLoading = true
			$0.posts = Post.mocks
		}
		await store.receive(\.processResponse) {
			$0.isLoading = false
			$0.posts = Post.mocks
		}
	}
}

