//
//  FetchRecipesApp.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import SwiftUI

@main
struct FetchRecipesApp: App {
    @StateObject private var viewModel = RecipeListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
