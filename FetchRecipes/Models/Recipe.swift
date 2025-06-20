//
//  Recipe.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/18/25.
//

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID
    @MojibakeSafe var name: String
    let cuisine: String
    let photoURLLarge: URL?
    let photoURLSmall: URL?
    let sourceURL: URL?
    let youtubeURL: URL?

    enum CodingKeys: String, CodingKey {
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case id = "uuid"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.cuisine == rhs.cuisine &&
        lhs.photoURLLarge == rhs.photoURLLarge &&
        lhs.photoURLSmall == rhs.photoURLSmall &&
        lhs.sourceURL == rhs.sourceURL &&
        lhs.youtubeURL == rhs.youtubeURL
    }
}