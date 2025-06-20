//
//  RecipeListViewModel.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var deviceOrientation: UIDeviceOrientation? = nil
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var sortOption: SortOption = .alphabetical {
        didSet { sortRecipes() }
    }

    enum SortOption: String, CaseIterable, Identifiable {
        case alphabetical = "Alphabetical"
        case cuisine = "Cuisine"
        var id: String { rawValue }
    }

    func loadRecipes() {
        isLoading = true
        Task {
            defer { isLoading = false }
            
            do {
                let fetched = try await RecipeAPI.fetchRecipes()
                
                self.recipes = fetched
                sortRecipes()
                isLoading = false
            } catch {
                self.recipes = []
            }
        }
    }

    func updateOrientation(_ orientation: UIDeviceOrientation) {
        deviceOrientation = orientation
    }

    func sortRecipes() {
        switch sortOption {
        case .alphabetical:
            recipes.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .cuisine:
            recipes.sort { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        }
    }
    
    func gridColumns(for size: CGSize) -> [GridItem] {
        let isLandscape = size.width > size.height
        let columns = isLandscape ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: columns)
    }
}
