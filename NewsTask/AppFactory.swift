//
//  AppFactory.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//

import SwiftUI

@MainActor
final class AppFactory {
    private let newsProvider: NewsProvider
    
    init(newsProvider: NewsProvider) {
        self.newsProvider = newsProvider
    }
    
    func makeArticlesListView(
        category: NewsCategory? = nil,
        searchable: Bool = false
    ) -> ArticlesListView {
        let vm = ArticlesListViewModel(
            newsProvider: newsProvider,
            category: category
        )
        return ArticlesListView(vm: vm, searchable: searchable)
    }
}

extension AppFactory {
    static let mock = AppFactory(newsProvider: MockNewsProvider())
}

extension EnvironmentValues {
    @Entry var appFactory: AppFactory = .mock
}
