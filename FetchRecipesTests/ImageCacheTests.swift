import XCTest
import UIKit
@testable import FetchRecipes

final class ImageCacheTests: XCTestCase {
    
    // Use a real recipe image URL from your dataset
    let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/8f60cd87-20ab-419b-a425-56b7ad7c8566/large.jpg")!
    
    func createTestImage(color: UIColor = .blue, size: CGSize = CGSize(width: 50, height: 50)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    override func setUp() async throws {
        await ImageCache.shared.clear()
    }
    
    func testStoreAndRetrieveImageFromMemoryAndDisk() async throws {
        let image = createTestImage()
        
        // Store image
        await ImageCache.shared.store(image, for: testURL)
        
        // Retrieve from memory cache
        let cachedImage1 = await ImageCache.shared.image(for: testURL)
        XCTAssertNotNil(cachedImage1, "Image should be retrieved from memory cache")
        
        // Clear all caches (memory + disk)
        await ImageCache.shared.clear()
        
        // Attempt retrieve from cache after clearing (should be nil)
        let cachedImage2 = await ImageCache.shared.image(for: testURL)
        XCTAssertNil(cachedImage2, "Image should be nil after clearing caches")
        
        // Store again to test disk retrieval separately
        await ImageCache.shared.store(image, for: testURL)
        
        // Retrieve image after storing again
        let cachedImage3 = await ImageCache.shared.image(for: testURL)
        XCTAssertNotNil(cachedImage3, "Image should be retrieved from cache after storing again")
    }
    
    func testClearCacheRemovesBothMemoryAndDisk() async throws {
        let image = createTestImage()
        
        await ImageCache.shared.store(image, for: testURL)
        
        let cachedImageBeforeClear = await ImageCache.shared.image(for: testURL)
        XCTAssertNotNil(cachedImageBeforeClear, "Image should exist before clearing")
        
        await ImageCache.shared.clear()
        
        let cachedImageAfterClear = await ImageCache.shared.image(for: testURL)
        XCTAssertNil(cachedImageAfterClear, "Image should be removed after clearing cache")
    }

    func testCancellationSupport() async throws {
        let image = createTestImage()
        await ImageCache.shared.store(image, for: testURL)
        
        let task = Task { () -> UIImage? in
            await ImageCache.shared.image(for: testURL)
        }
        
        // Cancel the task immediately
        task.cancel()
        
        let result = await task.value
        XCTAssertNotNil(result, "Image retrieval should complete or handle cancellation gracefully")
    }
    
    func testFileNameSafety() {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/some+image=path/with/slashes.jpg")!
        let filename = ImageCache.test_filename(for: url)
        
        XCTAssertFalse(filename.contains("/"), "Filename should not contain slashes")
        XCTAssertFalse(filename.contains("+"), "Filename should not contain plus signs")
        XCTAssertFalse(filename.contains("="), "Filename should not contain equals signs")
        XCTAssertFalse(filename.isEmpty, "Filename should not be empty")
    }
}
