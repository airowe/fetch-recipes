//
//  RecipeCell.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import SwiftUI

struct RecipeCell: View {
    @ObservedObject var viewModel: RecipeCellViewModel
    @StateObject private var orientationObserver = DeviceOrientationObserver()
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
        
            CachedAsyncImageView(url: viewModel.recipe.photoURLSmall)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .clipped()
                .accessibilityHidden(true)
            VStack(spacing: 4) {
                Text(viewModel.recipe.name)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Recipe name: \(viewModel.recipe.name)")
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("Cuisine: \(viewModel.recipe.cuisine)")
            }
            .frame(maxWidth: .infinity, minHeight: 90, maxHeight: 90)
            .background(viewModel.isPressed ? Color.gray.opacity(0.3) : Color.clear)
        }
        .frame(maxWidth: .infinity, minHeight: 270, maxHeight: 270)
        .padding(8)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.18), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.12), radius: viewModel.cellShadowRadius, x: 0, y: 4)
        .background(viewModel.isPressed ? Color.gray.opacity(0.3) : Color.clear)
        .scaleEffect(viewModel.isPressed ? 0.95 : 1.0)
        .animation(.spring(), value: viewModel.isPressed)
        .simultaneousGesture(
            TapGesture().onEnded {
                viewModel.togglePressed()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    viewModel.togglePressed()
                }
            }
        )
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
