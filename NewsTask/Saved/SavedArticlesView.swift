//
//  SavedArticlesView.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//


import SwiftUI

struct SavedArticlesView: View {
    @ScaledMetric private var spacing = 16
    let articlesStore: ArticlesStore
    
    var body: some View {
        Group {
            if articlesStore.savedArticles.isEmpty {
                ContentUnavailableView(
                    "No Saved Articles",
                    systemImage: "bookmark.slash",
                    description: Text("Tap the bookmark icon or double-tap an image to save articles.")
                )
            } else {
                ScrollView(.vertical) {
                    LazyVStack(spacing: spacing) {
                        ForEach(articlesStore.savedArticles) { article in
                            ArticleCellView(article: article, isSaved: true) {
                                articlesStore.toggle(article)
                            }
                            .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        }
                    }
                    .padding()
                    .animation(.snappy, value: articlesStore.savedArticles.map(\.id))
                }
                .refreshable {
                    articlesStore.load()
                }
            }
        }
        .navigationTitle("Saved")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppFactory.mock.makeSavedArticlesView()
    }
}
