//
//  MojibakeSafe.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import Foundation

/// A property wrapper that attempts to fix common mojibake issues in decoded strings.
/// Mojibake (Japanese: 文字化け; IPA: [mod͡ʑibake], 'character transformation') is the garbled or gibberish text
/// that is the result of text being decoded using an unintended character encoding.
@propertyWrapper
struct MojibakeSafe: Codable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue.cleanedOfMojibake()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self.wrappedValue = rawValue.cleanedOfMojibake()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
