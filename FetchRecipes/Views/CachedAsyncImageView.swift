//
//  CachedAsyncImageView.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import SwiftUI
import UIKit

struct CachedAsyncImageView: View {
    let url: URL?
    
    @State private var uiImage: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .accessibilityHidden(true)
            } else if isLoading {
                ProgressView()
                    .frame(width: 60, height: 60)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
            }
        }
        .task(id: url) {
            guard let url = url else { return }
            isLoading = true
            if let cached = await ImageCache.shared.image(for: url) {
                uiImage = cached
            } else {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        uiImage = image
                        await ImageCache.shared.store(image, for: url)
                    }
                } catch {
                    print("Failed to load image from URL \(url): \(error.localizedDescription)")
                }
            }
            isLoading = false
        }
    }
}
