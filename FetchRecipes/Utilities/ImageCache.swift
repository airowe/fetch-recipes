//
//  ImageCache.swift
//  FetchRecipes
//
//  Created by Adam Rowe on 6/19/25.
//

import Foundation
import UIKit

actor ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    init() {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        self.cacheDirectory = urls[0].appendingPathComponent("RecipeImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func image(for url: URL) async -> UIImage? {
        let key = url.absoluteString as NSString
        
        // Try memory cache synchronously in actor
        if let image = memoryCache.object(forKey: key) {
            return image
        }
        
        // Build file URL and key string
        let fileURL = cacheDirectory.appendingPathComponent(Self.filename(for: url))
        
        // Load data from disk in a detached task
        let image = await Task.detached(priority: .utility) {
            if let data = try? Data(contentsOf: fileURL) {
                return UIImage(data: data)
            }
            return nil
        }.value
        
        // If loaded, set to cache in actor context
        if let image {
            memoryCache.setObject(image, forKey: key)
        }
        
        return image
    }
    
    private func cost(for image: UIImage) -> Int {
        let pixelWidth = Int(image.size.width * image.scale)
        let pixelHeight = Int(image.size.height * image.scale)
        let bytesPerPixel = 4
        return pixelWidth * pixelHeight * bytesPerPixel
    }
    
    func store(_ image: UIImage, for url: URL) async {
        let key = url.absoluteString as NSString
        let cost = cost(for: image)
        memoryCache.setObject(image, forKey: key, cost: cost)
        
        let fileURL = cacheDirectory.appendingPathComponent(Self.filename(for: url))
        if let data = image.jpegData(compressionQuality: 1.0) {
            await Task.detached(priority: .utility) {
                try? data.write(to: fileURL)
            }.value
        }
    }
    
    private static func filename(for url: URL) -> String {
        // Use a filesystem-safe base64-encoded version of the full URL string (no '/', '+', '=')
        if let data = url.absoluteString.data(using: .utf8) {
            var base64 = data.base64EncodedString()
            base64 = base64.replacingOccurrences(of: "/", with: "_")
            base64 = base64.replacingOccurrences(of: "+", with: "_")
            base64 = base64.replacingOccurrences(of: "=", with: "")
            return base64
        }
        return url.absoluteString.replacingOccurrences(of: "/", with: "_")
    }
    
    func clear() async {
        memoryCache.removeAllObjects()
        if let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) {
            for file in files {
                try? fileManager.removeItem(at: file)
            }
        }
    }
}

#if DEBUG
extension ImageCache {
    static func test_filename(for url: URL) -> String {
        return filename(for: url)
    }
}
#endif
