//
//  RecipeDetailViewModel.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import Combine
import UIKit

final class RecipeDetailViewModel: ObservableObject {
    let recipe: Recipe
    @Published var deviceOrientation: UIDeviceOrientation? = nil
    
    // Business logic: orientation-dependent image height
    var imageHeight: CGFloat {
        switch deviceOrientation {
        case .landscapeLeft, .landscapeRight:
            return 140
        case .portrait, .portraitUpsideDown:
            return 260
        default:
            return 260
        }
    }
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func updateOrientation(_ orientation: UIDeviceOrientation) {
        deviceOrientation = orientation
    }
}
