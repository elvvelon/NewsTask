//
//  ArticleCellView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI
import Kingfisher

struct ArticleCellView: View {
    @ScaledMetric private var spacing = 12
    let article: Article
    let onFavTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            // Header
            HStack {
                Text(article.author ?? "")
                Spacer()
                Text(article.publishedAt.formatted(date: .abbreviated, time: .shortened))
            }
            .font(.subheadline)
            .lineLimit(1)
            
            // Title
            Text(article.title)
                .font(.headline)
            
            // Body
            if let imageURL = article.urlToImage {
                KFImage(imageURL)
                    .resizable()
                    .placeholder { Color.gray }
                    .fade(duration: 0.25)
                    .frame(maxHeight: 500)
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
            }
            
            if let description = article.description {
                Text(description)
                    .lineLimit(3)
            }
            
            // Buttons
            HStack(spacing: spacing) {
                Spacer()
                
                Button(action: onFavTap) {
                    Image(systemName: article.isSaved ? "bookmark.fill" : "bookmark")
                }
                
                ShareLink(item: article.url)
                    .labelStyle(.iconOnly)
            }
        }
        .padding()
        .background(.quinary)
        .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    @Previewable @State var article = Article.mockList.first!
    VStack {
        ArticleCellView(article: article) { article.isSaved.toggle() }
    }
    .padding()
}
