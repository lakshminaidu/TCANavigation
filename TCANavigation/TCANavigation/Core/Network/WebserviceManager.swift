//
//  WebserviceManager.swift
//  TCA-ArchSample
//
//  Created by Kanna on 19/03/24.
//

import Foundation
import ComposableArchitecture

protocol WebServiceType {
    func fetch<T: Codable>(fromURL: String) async throws -> T?
}

extension WebServiceType {
    func fetch<T: Codable>(fromURL: String) async throws -> T {
        do {
            guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
            print(url.absoluteString)
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard 200...300 ~= response.statusCode else { throw NetworkError.badStatus }
            return try JSONDecoder().decode(T.self, from: data)
        } catch NetworkError.badUrl {
            print("There was an error creating the URL")
            throw NetworkError.badUrl
        } catch NetworkError.badResponse {
            print("Did not get a valid response")
            throw NetworkError.badResponse
        } catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
            throw NetworkError.badStatus
        } catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type")
            throw NetworkError.failedToDecodeResponse
        } catch {
            print("An error occured downloading the data")
            throw error
        }
    }
}


enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

class ApiManager: WebServiceType {
	static let shared: ApiManager = ApiManager()
}
