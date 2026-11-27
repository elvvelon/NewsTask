//
//  NewsProvider.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

protocol NewsProvider: Sendable {
    func fetchTopHeadlines(category: NewsCategory?, page: Int, pageSize: Int, ignoreCache: Bool) async throws -> [Article]
    func searchNews(query: String, page: Int, pageSize: Int, ignoreCache: Bool) async throws -> [Article]
}

struct NewsAPIProvider: NewsProvider {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchTopHeadlines(
        category: NewsCategory? = nil,
        page: Int = 1,
        pageSize: Int = 20,
        ignoreCache: Bool = false
    ) async throws -> [Article] {
        let response: NewsResponse = try await networkService.request(
            .topHeadlines(category: category, page: page, pageSize: pageSize),
            ignoreCache: ignoreCache
        )
        return response.articles
    }

    func searchNews(
        query: String,
        page: Int = 1,
        pageSize: Int = 20,
        ignoreCache: Bool = false
    ) async throws -> [Article] {
        let response: NewsResponse = try await networkService.request(
            .search(query: query, page: page, pageSize: pageSize),
            ignoreCache: ignoreCache
        )
        return response.articles
    }
}
