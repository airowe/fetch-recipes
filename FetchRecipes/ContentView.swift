//
//  ContentView.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: RecipeListViewModel
    
    var body: some View {
        RecipeListView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
        .environmentObject(RecipeListViewModel())
}
