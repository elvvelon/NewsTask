//
//  NetworkService.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation

actor NetworkService {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let apiKey: String
    
    private var cache: [URL: Data] = [:]
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init(),
        apiKey: String
    ) {
        self.session = session
        self.decoder = decoder
        self.apiKey = apiKey
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    func request<T>(_ endpoint: NewsEndpoint) async throws -> T where T : Decodable {
        let urlRequest = try await endpoint.makeRequest(apiKey: apiKey)
        
        if let url = urlRequest.url, let cachedData = cache[url] {
            return try decode(cachedData)
        }

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        if let url = urlRequest.url {
            cache[url] = data
        }

        return try decode(data)
    }
    
    func clearCache() {
        cache.removeAll()
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
