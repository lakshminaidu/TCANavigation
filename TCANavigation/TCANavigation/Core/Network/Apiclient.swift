//
//  ApiClient.swift
//  TCASample
//
//  Created by iSHIKA on 07/05/24.
//

import Foundation
import ComposableArchitecture

@DependencyClient
struct ApiClient: WebServiceType {
    
}

extension DependencyValues {
    var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}

extension ApiClient: DependencyKey {
    static let liveValue = Self()
}
