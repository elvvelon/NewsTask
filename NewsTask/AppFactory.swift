//
//  AppFactory.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//

import SwiftUI
import SwiftData

/// Creates screens with their dependencies.
/// It is passed through the SwiftUI environment, so views don't need to know about the network or the database.
@MainActor
final class AppFactory {
    private let newsProvider: NewsProvider
    let articlesStore: ArticlesStore
    
    init(newsProvider: NewsProvider, articlesStore: ArticlesStore) {
        self.newsProvider = newsProvider
        self.articlesStore = articlesStore
    }
    
    func makeArticlesListView(
        category: NewsCategory? = nil,
        searchable: Bool = false
    ) -> ArticlesListView {
        let vm = ArticlesListViewModel(
            newsProvider: newsProvider,
            category: category
        )
        return ArticlesListView(vm: vm, articlesStore: articlesStore, searchable: searchable)
    }
    
    func makeSavedArticlesView() -> SavedArticlesView {
        SavedArticlesView(articlesStore: articlesStore)
    }
}

extension AppFactory {
    static let mock: AppFactory = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: SavedArticle.self, configurations: config)
        let store = ArticlesStore(container: container)
        return AppFactory(newsProvider: MockNewsProvider(), articlesStore: store)
    }()
}

extension EnvironmentValues {
    @Entry var appFactory: AppFactory = .mock
}
