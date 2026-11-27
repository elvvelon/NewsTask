//
//  SavedArticle.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//

import SwiftData
import Foundation

@Model
final class SavedArticle {
    @Attribute(.unique) var articleURL: URL
    var author: String?
    var title: String
    var articleDescription: String?
    var imageURL: URL?
    var publishedAt: Date
    var content: String?
    var savedAt: Date

    init(from article: Article) {
        self.articleURL = article.articleURL
        self.author = article.author
        self.title = article.title
        self.articleDescription = article.description
        self.imageURL = article.imageURL
        self.publishedAt = article.publishedAt
        self.content = article.content
        self.savedAt = .now
    }

    func toDomain() -> Article {
        Article(
            author: author,
            title: title,
            description: articleDescription,
            articleURL: articleURL,
            imageURL: imageURL,
            publishedAt: publishedAt,
            content: content,
            isSaved: true
        )
    }
}
