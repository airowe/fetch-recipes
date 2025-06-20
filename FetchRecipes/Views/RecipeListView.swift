import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var viewModel: RecipeListViewModel
    @StateObject private var orientationObserver = DeviceOrientationObserver()
    
    var body: some View {
        ZStack {
            if viewModel.isLoading && viewModel.recipes.isEmpty {
                loadingView
            } else {
                NavigationView {
                    GeometryReader { geometry in
                        if viewModel.isLoading {
                            ProgressView("Loading Recipes…")
                                .accessibilityLabel("Loading Recipes")
                                .navigationTitle("Recipes")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        } else if viewModel.recipes.isEmpty {
                            emptyStateView
                                .navigationTitle("Recipes")
                        } else {
                            VStack(spacing: 0) {
                                Picker("Sort by", selection: $viewModel.sortOption) {
                                    ForEach(RecipeListViewModel.SortOption.allCases) { option in
                                        Text(option.rawValue).tag(option)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding()
                                .accessibilityLabel("Sort recipes")
                                
                                ScrollView {
                                    LazyVGrid(columns: viewModel.gridColumns(for: geometry.size), spacing: 16) {
                                        ForEach(viewModel.recipes) { recipe in
                                            let cellVM = RecipeCellViewModel(recipe: recipe)
                                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                                RecipeCell(viewModel: cellVM)
                                            }
                                            .id(recipe.id)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .refreshable {
                                    viewModel.loadRecipes()
                                }
                            }
                            .navigationTitle("Recipes")
                        }
                    }
                }
                .onAppear {
                    viewModel.loadRecipes()
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
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            Image(systemName: "fork.knife")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.accentColor)
                .accessibilityHidden(true)
            Text("Fetching Recipes…")
                .font(.title2)
                .padding(.top, 8)
                .accessibilityLabel("Fetching Recipes")
            Spacer()
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var emptyStateView: some View {
        VStack {
            Text("No recipes available.")
                .accessibilityLabel("No recipes available")
            Button("Refresh") {
                viewModel.loadRecipes()
            }
            .accessibilityLabel("Refresh Button")
        }
    }
}

#Preview {
    let viewModel = RecipeListViewModel()
    Task {
        if let (data, _) = try? await URLSession.shared.data(from: RecipeAPI.recipesURL) {
            if let decoded = try? JSONDecoder().decode(RecipeListResponse.self, from: data) {
                viewModel.recipes = decoded.recipes ?? []
            }
        }
    }
    return RecipeListView()
        .environmentObject(viewModel)
}



