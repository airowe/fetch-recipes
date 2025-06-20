//
//  RecipeCellViewModel.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import SwiftUI

final class RecipeCellViewModel: ObservableObject, Identifiable {
    
    var cellShadowRadius: CGFloat {
        switch deviceOrientation {
        case .landscapeLeft, .landscapeRight:
            return 4
        case .portrait, .portraitUpsideDown:
            return 8
        default:
            return 8
        }
    }
    let recipe: Recipe
    @Published var isPressed: Bool = false
    @Published var deviceOrientation: UIDeviceOrientation? = nil
    
    var id: UUID { recipe.id }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func togglePressed() {
        withAnimation(.spring()) {
            isPressed.toggle()
        }
    }
    
    func updateOrientation(_ orientation: UIDeviceOrientation) {
        deviceOrientation = orientation
    }
}
