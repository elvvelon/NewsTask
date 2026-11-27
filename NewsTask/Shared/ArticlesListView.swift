//
//  ArticlesListView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI

struct ArticlesListView: View {
    @ScaledMetric private var spacing = 16
    @State var vm: ArticlesListViewModel
    let articlesStore: ArticlesStore
    let searchable: Bool
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: spacing) {
                ForEach(vm.articles) { article in
                    ArticleCellView(article: article, isSaved: articlesStore.isSaved(article)) {
                        articlesStore.toggle(article)
                    }
                    .task {
                        if article.id == vm.articles.last?.id {
                            await vm.loadNextPage()
                        }
                    }
                }
                
                if vm.hasMorePages {
                    ProgressView()
                }
            }
            .padding()
        }
        .background {
            if !vm.searchQuery.isEmpty && vm.articles.isEmpty {
                ContentUnavailableView.search(text: vm.searchQuery)
            }
        }
        
        .overlay(alignment: .top) {
            if let errorMessage = vm.errorMessage {
                ErrorBannerView(message: errorMessage) {
                    vm.errorMessage = nil
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.snappy, value: vm.errorMessage)
        
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        
        .task { await vm.firstLoad() }
        .refreshable {
            await vm.firstLoad(force: true)
        }
        .addSearchField(enabled: searchable, text: $vm.searchQuery)
        .task(id: vm.searchQuery) {
            if !vm.searchQuery.trimmingCharacters(in: .whitespaces).isEmpty {
                guard let _ = try? await Task.sleep(for: .milliseconds(500))
                else { return }
            }
            await vm.firstLoad(force: true)
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func addSearchField(
        enabled: Bool = true,
        text: Binding<String>,
        prompt: String = "Search..."
    ) -> some View {
        if enabled {
            self.searchable(text: text, placement: .navigationBarDrawer(displayMode: .always), prompt: prompt)
        } else {
            self
        }
    }
}

#Preview {
    NavigationStack {
        AppFactory.mock.makeArticlesListView(searchable: true)
            .navigationTitle("News")
    }
}
