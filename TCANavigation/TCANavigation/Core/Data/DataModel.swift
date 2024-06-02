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

struct Post: Codable, Identifiable, Equatable {
    let id: Int
    let userId: Int
    let title: String?
    let body: String?
}

struct Photo: Codable, Identifiable, Equatable {
    let id: Int
    let albumId: Int
    let title: String?
    let url: String?
    let thumbnailUrl: String?
}
