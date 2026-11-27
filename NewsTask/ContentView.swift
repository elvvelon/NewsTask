//
//  ContentView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.appFactory) private var appFactory

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                NavigationStack {
                    appFactory.makeArticlesListView(searchable: true)
                        .navigationTitle("News")
                }
            }
            
            Tab("Categories", systemImage: "list.bullet") {
                NavigationStack {
                    CategoriesView()
                }
            }
            
            Tab("Saved", systemImage: "bookmark") {
                NavigationStack {
                    appFactory.makeSavedArticlesView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.appFactory, AppFactory.mock)
}
