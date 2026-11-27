//
//  ArticlesListViewModel.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI

@Observable @MainActor
final class ArticlesListViewModel {
    private let newsProvider: NewsProvider
    
    var articles: [Article] = []
    var searchQuery = ""
    var category: NewsCategory?
    
    var errorMessage: String?
    private(set) var isLoading = false
    private(set) var hasMorePages = true
    private var nextPage = 1
    private let pageSize = 20
    
    init(newsProvider: NewsProvider, category: NewsCategory? = nil) {
        self.newsProvider = newsProvider
        self.category = category
    }
    
    func firstLoad(force: Bool = false) async {
        guard force || articles.isEmpty, !isLoading else { return }
        
        await perform {
            let fetchedArticles = try await fetchPage(1, ignoreCache: force)
            try Task.checkCancellation()
            withAnimation {
                articles = fetchedArticles
                hasMorePages = !fetchedArticles.isEmpty
            }
            nextPage = 2
        }
    }
    
    func loadNextPage() async {
        guard !isLoading, hasMorePages else { return }
        
        await perform {
            let fetchedArticles = try await fetchPage(nextPage)
            withAnimation {
                articles.append(contentsOf: fetchedArticles)
                hasMorePages = !fetchedArticles.isEmpty
            }
            nextPage += 1
        }
    }
    
    private func perform(_ action: () async throws -> Void) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await action()
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchPage(_ page: Int, ignoreCache: Bool = false) async throws -> [Article] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        return if query.isEmpty {
            try await newsProvider.fetchTopHeadlines(
                category: category,
                page: page,
                pageSize: pageSize,
                ignoreCache: ignoreCache
            )
        } else {
            try await newsProvider.searchNews(
                query: query,
                page: page,
                pageSize: pageSize,
                ignoreCache: ignoreCache
            )
        }
    }
}
