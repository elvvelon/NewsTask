//
//  CategoriesView.swift
//  NewsTask
//
//  Created by vvelon on 26.11.2026.
//

import SwiftUI

struct CategoriesView: View {
    @Environment(\.appFactory) private var appFactory
    
    var body: some View {
        List {
            ForEach(NewsCategory.allCases) { category in
                NavigationLink {
                    appFactory.makeArticlesListView(category: category)
                        .navigationTitle(category.name)
                } label: {
                    Label(category.name, systemImage: category.iconName)
                }
            }
        }
        .navigationTitle("Categories")
    }
}

extension NewsCategory: Identifiable {
    var id: String { self.rawValue }
    
    var name: String {
        self.rawValue.capitalized
    }
    
    var iconName: String {
        switch self {
        case .general: "newspaper"
        case .business: "suitcase"
        case .entertainment: "figure.dance"
        case .health: "cross"
        case .science: "flask"
        case .sports: "bicycle"
        case .technology: "cpu"
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesView()
    }
}
