//
//  ArticlesStore.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//

import Foundation
import SwiftData

@Observable @MainActor
final class ArticlesStore {
    private let container: ModelContainer
    private let context: ModelContext
    
    private(set) var savedArticles: [Article] = []
    private(set) var savedIDs: Set<URL> = []
    
    init(container: ModelContainer) {
        self.container = container
        self.context = container.mainContext
        load()
    }
    
    func isSaved(_ article: Article) -> Bool {
        savedIDs.contains(article.id)
    }
    
    func toggle(_ article: Article) {
        isSaved(article) ? remove(article) : save(article)
    }
    
    private func load() {
        let descriptor = FetchDescriptor<SavedArticle>(
            sortBy: [SortDescriptor(\.savedAt, order: .reverse)]
        )
        let models = (try? context.fetch(descriptor)) ?? []
        savedArticles = models.map { $0.toDomain() }
        savedIDs = Set(savedArticles.map(\.id))
    }
    
    private func save(_ article: Article) {
        let model = SavedArticle(from: article)
        context.insert(model)
        try? context.save()
        load()
    }
    
    private func remove(_ article: Article) {
        let targetURL = article.articleURL
        let descriptor = FetchDescriptor<SavedArticle>(
            predicate: #Predicate { $0.articleURL == targetURL }
        )
        if let model = try? context.fetch(descriptor).first {
            context.delete(model)
            try? context.save()
            load()
        }
    }
}
