//
//  NewsEndpoint.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation

nonisolated enum NewsCategory: String, CaseIterable {
    case general, business, entertainment, health, science, sports, technology
}

nonisolated enum NewsEndpoint {
    // MARK: - Endpoints
    
    case topHeadlines(category: NewsCategory? = nil, page: Int, pageSize: Int = 20)
    case search(query: String, page: Int, pageSize: Int = 20)
    
    // MARK: - Private URL Components
    
    private var path: String {
        return switch self {
        case .topHeadlines: "/v2/top-headlines"
        case .search: "/v2/everything"
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .topHeadlines(let category, let page, let pageSize):
            var items = [
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
            if let category {
                items.append(URLQueryItem(name: "category", value: category.rawValue))
            }
            return items
            
        case .search(let query, let page, let pageSize):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "\(pageSize)")
            ]
        }
    }
    
    // MARK: - Request
    
    func makeRequest(apiKey: String) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsapi.org"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        return request
    }
}
