//
//  ArticleCellView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI
import Kingfisher

struct AnimationValues {
    var scale = 0.0
    var opacity = 0.0
}

struct ArticleCellView: View {
    @ScaledMetric private var spacing = 12
    @State private var likeTrigger = 0
    let article: Article
    let isSaved: Bool
    let onFavTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            // Header
            HStack {
                Text(article.author ?? "")
                Spacer()
                Text(article.publishedAt.formatted(.relative(presentation: .named)))
            }
            .font(.subheadline)
            .lineLimit(1)
            
            // Title
            Text(article.title)
                .font(.headline)
            
            // Body
            imageView
            
            if let description = article.description {
                Text(description)
                    .lineLimit(3)
            }
            
            buttonsView
        }
        .padding()
        .background(.quinary)
        .clipShape(.rect(cornerRadius: 20))
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private var imageView: some View {
        if let imageURL = article.imageURL {
            Color.clear
                .aspectRatio(16 / 9, contentMode: .fit)
                .overlay {
                    KFImage(imageURL)
                        .resizable()
                        .placeholder { Color.gray.opacity(0.3) }
                        .fade(duration: 0.25)
                        .scaledToFill()
                        // Double tap only adds to saved, removing is done with the button
                        .onTapGesture(count: 2) {
                            if !isSaved { onFavTap() }
                            likeTrigger += 1
                        }
                }
                .clipShape(.rect(cornerRadius: 12))
                .overlay {
                    bookmarkAnimationView
                }
        }
    }
    
    private var buttonsView: some View {
        HStack(spacing: 18) {
            Button(
                "Save",
                systemImage: isSaved ? "bookmark.fill" : "bookmark",
                action: onFavTap
            )
            
            ShareLink(item: article.articleURL)
        }
        .font(.title3)
        .labelStyle(.iconOnly)
    }
    
    private var bookmarkAnimationView: some View {
        BookmarkView()
            .keyframeAnimator(initialValue: AnimationValues(), trigger: likeTrigger) { content, value in
                content
                    .scaleEffect(value.scale)
                    .opacity(value.opacity)
            } keyframes: { _ in
                KeyframeTrack(\.scale) {
                    SpringKeyframe(1.2, duration: 0.25)
                    SpringKeyframe(1.0, duration: 0.15)
                    LinearKeyframe(1.0, duration: 0.3)
                    LinearKeyframe(0.8, duration: 0.2)
                }
                KeyframeTrack(\.opacity) {
                    LinearKeyframe(1, duration: 0.1)
                    LinearKeyframe(1, duration: 0.6)
                    LinearKeyframe(0, duration: 0.2)
                }
            }
            .allowsHitTesting(false)
    }
}

#Preview {
    @Previewable @State var article = Article.mockList.first!
    VStack {
        ArticleCellView(article: article, isSaved: article.isSaved) { article.isSaved.toggle() }
    }
    .padding()
}
