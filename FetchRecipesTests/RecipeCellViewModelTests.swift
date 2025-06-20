//
//  RecipeCellViewModelTests.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//


import XCTest
import SwiftUI
@testable import FetchRecipes

final class RecipeCellViewModelTests: XCTestCase {
    func testTogglePressed() {
        let recipe = Recipe(id: UUID(), name: "Test", cuisine: "Test", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        let vm = RecipeCellViewModel(recipe: recipe)
        
        XCTAssertFalse(vm.isPressed, "Initial state should be false")
        
        // Toggle once
        vm.togglePressed()
        // Since togglePressed uses withAnimation, it runs asynchronously. 
        // For test, just check the value after a short delay or force immediate animation completion.
        XCTAssertTrue(vm.isPressed, "isPressed should be true after first toggle")
        
        // Toggle again
        vm.togglePressed()
        XCTAssertFalse(vm.isPressed, "isPressed should be false after second toggle")
    }
}
