//
//  MockNewsService.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import Foundation

struct MockNewsService: NewsServiceProtocol {
    var articles: [Article]
    var shouldThrowError: Bool
    var delay: Duration

    init(
        articles: [Article] = Article.mockList,
        shouldThrowError: Bool = false,
        delay: Duration = .milliseconds(300)
    ) {
        self.articles = articles
        self.shouldThrowError = shouldThrowError
        self.delay = delay
    }

    func fetchTopHeadlines(category: NewsCategory? = nil, page: Int = 1) async throws -> [Article] {
        return try await simulateNetwork()
    }

    func searchNews(query: String, page: Int = 1) async throws -> [Article] {
        return try await simulateNetwork()
    }

    private func simulateNetwork() async throws  -> [Article] {
        if delay > .zero {
            try await Task.sleep(for: delay)
        }
        if shouldThrowError {
            throw NetworkError.invalidResponse(statusCode: 500)
        }
        return articles
    }
}


extension Article {
    static let mockList: [Article] = [
        Article(
            author: "Andrew Liszewski",
            title: "Apple announces release dates for the first Apple Home Collection smart devices",
            description: "The first few smart home devices and accessories that Apple co-developed with LG Electronics and Schneider Electric for its new Apple Home Collection are now available for preorder.",
            url: "https://www.theverge.com/tech/1032920/apple-smart-home-collection-release-ship-dates-available-pricing",
            urlToImage: "https://platform.theverge.com/wp-content/uploads/sites/2/2026/11/applehome.jpg?quality=90&strip=all&crop=0%2C10.752607989199%2C100%2C78.494784021602&w=1200",
            publishedAt: ISO8601DateFormatter().date(from: "2026-11-13T15:22:14Z") ?? .now,
            content: "You can preorder several of the devices today, with shipping expected to start in mid-December."
        ),
        Article(
            author: "Nena Farrell",
            title: "Apple HomeView Review (2026): Should’ve Been Better",
            description: "Apple’s HomeView marks a very late arrival to the smart display world, and one that should’ve left me more impressed.",
            url: "https://www.wired.com/review/apple-homeview-review/",
            urlToImage: "https://media.wired.com/photos/6afcde919e5594b1abe45b8b/2:3/w_532,h_798,c_limit/Review--Apple-HomeView.jpg",
            publishedAt: ISO8601DateFormatter().date(from: "2026-11-18T10:18:00Z") ?? .now,
            content: "Pressing and holding on the face of the HomeView allows you to customize your various faces."
        ),
        Article(
            author: "Jay Peters",
            title: "Apple announces its first touchscreen MacBook Pro",
            description: "Apple announced an all-new MacBook Pro laptop with an OLED touchscreen at its \"Pro and tell\" event on Wednesday.",
            url: "https://www.theverge.com/gadgets/1019554/apple-touchscreen-macbook-pro-and-tell",
            urlToImage: "https://platform.theverge.com/wp-content/uploads/sites/2/2026/10/lcimg-e1e7d9fc-8e5b-4975-8923-62546f325915.jpeg?quality=90&strip=all&crop=0%2C15.125048497979%2C100%2C69.749903004041&w=1200",
            publishedAt: ISO8601DateFormatter().date(from: "2026-10-28T17:10:09Z") ?? .now,
            content: "Apple has long resisted the idea of touchscreen laptops until now."
        ),
        Article(
            author: "Mike Pearl",
            title: "Touchscreen MacBook Pro to Reportedly Start at $2,899 for 14-Inch, $3,399 for 16-Inch",
            description: "Anonymous sources tell Bloomberg Apple has “discussed” some wild prices.",
            url: "https://gizmodo.com/touchscreen-macbook-pro-to-reportedly-start-at-2899-for-14-inch-3399-for-16-inch-2000831512",
            urlToImage: "https://gizmodo.com/app/uploads/2025/10/gizmodo-social-1200x675-1.jpg",
            publishedAt: ISO8601DateFormatter().date(from: "2026-10-28T00:47:33Z") ?? .now,
            content: "At Apples Pro and Tell event in Los Angeles on Wednesday, Apple is expected to unveil its most groundbreaking product."
        )
    ]
}
