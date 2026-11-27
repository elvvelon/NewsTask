//
//  NewsTaskApp.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI
import SwiftData

@main
struct NewsTaskApp: App {
    private let appFactory: AppFactory
    
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String,
              !apiKey.isEmpty,
              apiKey != "$(NEWS_API_KEY)"
        else {
            fatalError("API key not found!")
        }

        let container: ModelContainer
        do {
            container = try ModelContainer(for: SavedArticle.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        let networkService = NetworkService(apiKey: apiKey)
        let newsProvider = NewsAPIProvider(networkService: networkService)
        let articlesStore = ArticlesStore(container: container)
        appFactory = AppFactory(newsProvider: newsProvider, articlesStore: articlesStore)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appFactory, appFactory)
        }
    }
}
