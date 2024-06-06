//
//  ProfileReducerTests.swift
//  TCANavigationTests
//
//  Created by iSHIKA on 02/06/24.
//

import XCTest
import ComposableArchitecture
@testable import TCANavigation


final class ProfileReducerTests: XCTestCase {	
    @MainActor
    func test_logout() async {
		let store = TestStore(initialState: ProfileReducer.State()) {
			ProfileReducer()
		}
		await store.send(.logout) 
	}
    @MainActor
	func test_fetchPhotos() async {
		let store = TestStore(initialState: ProfileReducer.State()) {
			ProfileReducer()
		} withDependencies: {
			$0.apiClient.fetchPhotos = { url in
				return Photo.mocks
			}
		}
		await store.send(.fetchdData) {
			$0.isLoading = true
		}
		await store.receive(\.processResponse) {
			$0.isLoading = false
			$0.photos = Photo.mocks
		}
	}
}
