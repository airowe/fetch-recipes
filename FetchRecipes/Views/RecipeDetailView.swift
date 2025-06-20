//
//  RecipeDetailView.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import SwiftUI

struct RecipeDetailView: View {
    @StateObject private var viewModel: RecipeDetailViewModel
    @StateObject private var orientationObserver = DeviceOrientationObserver()
    
    init(recipe: Recipe) {
        _viewModel = StateObject(wrappedValue: RecipeDetailViewModel(recipe: recipe))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CachedAsyncImageView(url: viewModel.recipe.photoURLLarge ?? viewModel.recipe.photoURLSmall)
                    .frame(height: viewModel.imageHeight)
                    .cornerRadius(12)
                    .accessibilityHidden(true)
                
                Text(viewModel.recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .accessibilityLabel("Recipe name: \(viewModel.recipe.name)")
                
                Text(viewModel.recipe.cuisine)
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Cuisine: \(viewModel.recipe.cuisine)")
                
                if let sourceURL = viewModel.recipe.sourceURL {
                    Button(action: {
                        UIApplication.shared.open(sourceURL)
                    }) {
                        Label("Open Original Recipe", systemImage: "safari")
                            .font(.headline)
                    }
                    .accessibilityLabel("Open Original Recipe in browser")
                }
                if let youtubeURL = viewModel.recipe.youtubeURL {
                    VideoPlayerView(url: youtubeURL)
                        .frame(height: 220)
                        .cornerRadius(12)
                        .accessibilityLabel("Recipe video player")
                }
                Spacer()
            }
            .padding()
        }
        .onAppear {
            orientationObserver.start()
        }
        .onDisappear {
            orientationObserver.stop()
        }
        .onChange(of: orientationObserver.orientation) { newOrientation, _ in
            viewModel.updateOrientation(newOrientation)
        }
    }
    

}


#Preview {
    RecipeDetailView(recipe: Recipe(
        id: UUID(),
        name: "Spaghetti Carbonara",
        cuisine: "Italian",
        photoURLLarge: URL(string: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"),
        photoURLSmall: URL(string: "https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg"),
        sourceURL: URL(string: "https://www.themealdb.com/meal/52772"),
        youtubeURL: URL(string: "https://www.youtube.com/watch?v=3AAdKl1UYZs")
    ))
}

