//
//  NewsService.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

protocol NewsServiceProtocol: Sendable {
    func fetchTopHeadlines(category: NewsCategory?, page: Int) async throws -> [Article]
    func searchNews(query: String, page: Int) async throws -> [Article]
}

struct NewsService: NewsServiceProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTopHeadlines(category: NewsCategory? = nil, page: Int = 1) async throws -> [Article] {
        let response: NewsResponse = try await networkService.request(
            .topHeadlines(category: category, page: page)
        )
        return response.articles
    }

    func searchNews(query: String, page: Int = 1) async throws -> [Article] {
        let response: NewsResponse = try await networkService.request(
            .search(query: query, page: page)
        )
        return response.articles
    }
}
