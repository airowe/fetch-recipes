import XCTest
@testable import FetchRecipes

final class RecipeTests: XCTestCase {
    func testRecipeDecoding_withValidJSON_decodesCorrectly() throws {
        let json = """
        {
            "cuisine": "British",
            "name": "Bakewell Tart",
            "photo_url_large": "https://some.url/large.jpg",
            "photo_url_small": "https://some.url/small.jpg",
            "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
            "source_url": "https://some.url/index.html",
            "youtube_url": "https://www.youtube.com/watch?v=some.id"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)
        XCTAssertEqual(recipe.name, "Bakewell Tart")
        XCTAssertEqual(recipe.cuisine, "British")
        XCTAssertEqual(recipe.id, UUID(uuidString: "eed6005f-f8c8-451f-98d0-4088e2b40eb6"))
        XCTAssertEqual(recipe.photoURLLarge, URL(string: "https://some.url/large.jpg"))
        XCTAssertEqual(recipe.photoURLSmall, URL(string: "https://some.url/small.jpg"))
        XCTAssertEqual(recipe.sourceURL, URL(string: "https://some.url/index.html"))
        XCTAssertEqual(recipe.youtubeURL, URL(string: "https://www.youtube.com/watch?v=some.id"))
    }

    func testRecipeDecoding_withMissingOptionalFields_decodesCorrectly() throws {
        let json = """
        {
            "cuisine": "French",
            "name": "Quiche Lorraine",
            "uuid": "123e4567-e89b-12d3-a456-426614174000"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        let recipe = try decoder.decode(Recipe.self, from: json)
        XCTAssertEqual(recipe.name, "Quiche Lorraine")
        XCTAssertEqual(recipe.cuisine, "French")
        XCTAssertEqual(recipe.id, UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        XCTAssertNil(recipe.photoURLLarge)
        XCTAssertNil(recipe.photoURLSmall)
        XCTAssertNil(recipe.sourceURL)
        XCTAssertNil(recipe.youtubeURL)
    }

    func testRecipeDecoding_withMalformedJSON_throwsError() {
        let json = """
        {
            "cuisine": "Italian",
            "name": "Lasagna",
            "uuid": 12345
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        XCTAssertThrowsError(try decoder.decode(Recipe.self, from: json))
    }
    
    func testFetchRecipes_withMalformedData_throwsMalformedDataError() async {
        do {
            _ = try await RecipeAPI.fetchRecipes(from: RecipeAPI.malformedURL)
            XCTFail("Expected malformedData error, but fetchRecipes succeeded")
        } catch let error as RecipeAPIError {
            XCTAssertEqual(error, .malformedData, "Expected .malformedData but got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
    
    func testFetchRecipes_withEmptyData_throwsEmptyDataError() async {
        do {
            _ = try await RecipeAPI.fetchRecipes(from: RecipeAPI.emptyURL)
            XCTFail("Expected emptyData error, but fetchRecipes succeeded")
        } catch let error as RecipeAPIError {
            XCTAssertEqual(error, .emptyData, "Expected .emptyData but got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}
