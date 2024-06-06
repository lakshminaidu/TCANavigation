//
//  ApiClient.swift
//  TCASample
//
//  Created by iSHIKA on 07/05/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct ApiClient {
	var fetchPosts: (String) async throws -> [Post]
	var fetchTodos: (String) async throws -> [TodoItem]
	var fetchPhotos: (String) async throws -> [Photo]
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

extension ApiClient: DependencyKey {
	static var liveValue = Self(
		fetchPosts: { fromURL in
			return try await ApiManager.shared.fetch(fromURL: fromURL)
		}, fetchTodos: { fromURL in
			return try await ApiManager.shared.fetch(fromURL: fromURL)
		}, fetchPhotos: { fromURL in
			return try await ApiManager.shared.fetch(fromURL: fromURL)
		}
	)

	static let mock = Self(
		fetchPosts: { fromURL in
			return Post.mocks
		}, fetchTodos: { fromURL in
			return TodoItem.mocks
		}, fetchPhotos: { fromURL in
			return Photo.mocks
		}
	  )
}

