//
//  BookmarkView.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//

import SwiftUI

struct BookmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height * 0.7))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct BookmarkView: View {
    var body: some View {
        BookmarkShape()
            .fill(.tint)
            .stroke(.tint, style: StrokeStyle(lineWidth: 12, lineJoin: .round))
            .compositingGroup()
            .frame(width: 60, height: 100)
            .shadow(color: .black.opacity(0.6), radius: 12, x: 4, y: 6)
    }
}

#Preview {
    BookmarkView()
}
