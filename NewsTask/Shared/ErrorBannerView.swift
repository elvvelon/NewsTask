//
//  ErrorBannerView.swift
//  NewsTask
//
//  Created by vvelon on 27.11.2026.
//


import SwiftUI

/// Error message at the top of the screen.
/// Hides after 3.5 seconds or when the user taps it.
struct ErrorBannerView: View {
    let message: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
                .font(.title3)
            
            Text(message)
                .font(.subheadline)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button("Dismiss", systemImage: "xmark", action: onDismiss)
                .labelStyle(.iconOnly)
                .font(.footnote.bold())
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.red.opacity(0.3), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.15), radius: 10, y: 5)
        .padding(.horizontal)
        .onTapGesture(perform: onDismiss)
        .task(id: message) {
            guard let _ = try? await Task.sleep(for: .seconds(3.5)) else { return }
            onDismiss()
        }
    }
}


#Preview {
    ErrorBannerView(message: "Some error.") {}
}
