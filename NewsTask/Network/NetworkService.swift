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
    
    private let cache = NSCache<NSURL, NSData>()
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = .init(),
        apiKey: String,
        cacheLimit: Int = 50
    ) {
        self.session = session
        self.decoder = decoder
        self.apiKey = apiKey
        self.decoder.dateDecodingStrategy = .iso8601
        self.cache.countLimit = cacheLimit
    }
    
    func request<T>(_ endpoint: NewsEndpoint, ignoreCache: Bool = false) async throws -> T where T : Decodable {
        let urlRequest = try await endpoint.makeRequest(apiKey: apiKey)
        
        if !ignoreCache,
           let url = urlRequest.url as NSURL?,
           let cachedData = cache.object(forKey: url) {
            return try decode(cachedData as Data)
        }

        let (data, response) = try await session.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        if let url = urlRequest.url as NSURL? {
            cache.setObject(data as NSData, forKey: url)
        }

        return try decode(data)
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
