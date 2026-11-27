//
//  ContentView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
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
        }
    }
}

#Preview {
    ContentView()
        .environment(\.appFactory, AppFactory.mock)
}
