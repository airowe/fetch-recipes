//
//  RecipeAPIError.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import Foundation

enum RecipeAPIError: Error, Equatable {
    case networkError(Error)
    case decodingError(Error)
    case malformedData
    case emptyData
    
    static func == (lhs: RecipeAPIError, rhs: RecipeAPIError) -> Bool {
        switch (lhs, rhs) {
        case (.malformedData, .malformedData),
            (.emptyData, .emptyData):
            return true
        case (.networkError, .networkError),
            (.decodingError, .decodingError):
            return false
        default:
            return false
        }
    }
}

struct RecipeAPI {
    static let recipesURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
    static let malformedURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json")!
    static let emptyURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json")!

    static func fetchRecipes(from url: URL = recipesURL) async throws -> [Recipe] {
        do {
            let (rawData, _) = try await URLSession.shared.data(from: url)
            
            guard let latin1String = String(data: rawData, encoding: .isoLatin1) else {
                throw RecipeAPIError.malformedData
            }
            
            let cleanedString = latin1String
                .replacingOccurrences(of: "\n", with: "")
                .replacingOccurrences(of: "\r", with: "")
                .components(separatedBy: .controlCharacters).joined()
            
            guard let utf8Data = cleanedString.data(using: .utf8) else {
                throw RecipeAPIError.malformedData
            }
            
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(RecipeListResponse.self, from: utf8Data)
            
            guard let recipes = decoded.recipes, !recipes.isEmpty else {
                throw RecipeAPIError.emptyData
            }
            
            return recipes
        } catch _ as DecodingError {
            throw RecipeAPIError.malformedData
        } catch {
            throw RecipeAPIError.networkError(error)
        }
    }
}

struct RecipeListResponse: Decodable {
    let recipes: [Recipe]?
}
