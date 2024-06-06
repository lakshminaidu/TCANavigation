//
//  DataModel.swift
//  TCANavigation
//
//  Created by iSHIKA on 01/06/24.
//

import Foundation

struct TodoItem: Codable, Identifiable, Equatable {
    let id: Int
    let userId: Int
    let title: String?
    let completed: Bool
}
extension TodoItem {
	static var mocks: [TodoItem] = [
		TodoItem(id: 1, userId: 1, title: "asdssad", completed: false),
		TodoItem(id: 2, userId: 1, title: "zdfas", completed: false),
	]
}

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let userId: Int
    let title: String?
    let body: String?
}

extension Post {
	static var mocks: [Post] = [
		Post(id: 1, userId: 1, title: "text", body: "text"),
		Post(id: 2, userId: 1, title: "dsfsf", body: "sdfsd")
	]
}
struct Photo: Codable, Identifiable, Equatable {
    let id: Int
    let albumId: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}

extension Photo {
	static var mocks: [Photo] = [
		Photo(id: 1, albumId: 1, title: "sadas", url: nil, thumbnailUrl: nil),
		Photo(id: 2, albumId: 2, title: "sadas", url: nil, thumbnailUrl: nil),

	]
}
