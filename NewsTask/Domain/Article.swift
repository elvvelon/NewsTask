//
//  Article.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let author: String?
    let title: String
    let description: String?
    let articleURL: URL
    let imageURL: URL?
    let publishedAt: Date
    let content: String?
    var isSaved = false

    var id: URL { articleURL }

    enum CodingKeys: String, CodingKey {
        case author, title, description, publishedAt, content
        case articleURL = "url"
        case imageURL = "urlToImage"
    }
}
