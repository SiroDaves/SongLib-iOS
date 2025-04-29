//
//  NetworkService.swift
//  SongLib
//
//  Created by Siro Daves on 29/04/2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
