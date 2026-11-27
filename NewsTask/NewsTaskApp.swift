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
    let appFactory: AppFactory
    
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "NewsAPIKey") as? String,
              !apiKey.isEmpty,
              apiKey != "$(NEWS_API_KEY)"
        else {
            fatalError("API key not found!")
        }

        let networkService = NetworkService(apiKey: apiKey)
        let newsProvider = NewsAPIProvider(networkService: networkService)
        appFactory = AppFactory(newsProvider: newsProvider)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.appFactory, appFactory)
        }
    }
}
