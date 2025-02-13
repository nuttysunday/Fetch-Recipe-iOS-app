//
//  ImageCachingTests.swift
//  FetchRecipeTests
//
//  Created by Shivam Ghodke on 2/13/25.
//

import Testing
import Foundation
import SwiftUI
@testable import FetchRecipe


struct ImageCachingTests {
    
    // Custom error enum for tests
    enum ImageCacheError: Error {
        case failedToCreateTestData
        case cachedImageIsNil
        case dataMismatch
        case retrievalFailed(String)
    }
    
    // Test 1: Basic image caching and retrieval
    @Test func testImageCachingAndRetrieval() async throws {
        // Given
        let cacheManager = ImageCacheManager.shared
        URLCache.shared.removeAllCachedResponses()
        
        // Create test image data on the main actor
        let testImageData = await createTestImageData()
        guard let testImageData else {
            throw ImageCacheError.failedToCreateTestData
        }
        
        let testURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!
        
        // When
        cacheManager.saveImage(testImageData, for: testURL)
        let cachedImage = cacheManager.getImage(for: testURL)
        
        // Then
        guard let cachedImage else {
            throw ImageCacheError.cachedImageIsNil
        }
        
        guard cachedImage.pngData() == testImageData else {
            throw ImageCacheError.dataMismatch
        }
        
        // Cleanup
        URLCache.shared.removeAllCachedResponses()
    }
    
    // Test 2: Cache miss for non-existent image
    @Test func testCacheMiss() async throws {
        // Given
        let cacheManager = ImageCacheManager.shared
        URLCache.shared.removeAllCachedResponses()
        let nonExistentURL = URL(string: "https://example.com/nonexistent.jpg")!
        
        // When
        let cachedImage = cacheManager.getImage(for: nonExistentURL)
        
        // Then
        guard cachedImage == nil else {
            throw ImageCacheError.retrievalFailed("Should return nil for non-cached image")
        }
    }
    
    // Test 3: Multiple cache operations
    @Test func testMultipleCacheOperations() async throws {
        // Given
        let cacheManager = ImageCacheManager.shared
        URLCache.shared.removeAllCachedResponses()
        
        let testImageData = await createTestImageData()
        guard let testImageData else {
            throw ImageCacheError.failedToCreateTestData
        }
        
        let urls = [
            URL(string: "https://example.com/image1.jpg")!,
            URL(string: "https://example.com/image2.jpg")!,
            URL(string: "https://example.com/image3.jpg")!
        ]
        
        // When
        for url in urls {
            cacheManager.saveImage(testImageData, for: url)
        }
        
        // Then
        for url in urls {
            guard let _ = cacheManager.getImage(for: url) else {
                throw ImageCacheError.retrievalFailed("Failed to retrieve cached image for \(url)")
            }
        }
    }
    
    // Test 4: Cache clearing
    @Test func testCacheClearing() async throws {
        // Given
        let cacheManager = ImageCacheManager.shared
        let testImageData = await createTestImageData()
        guard let testImageData else {
            throw ImageCacheError.failedToCreateTestData
        }
        let testURL = URL(string: "https://example.com/test.jpg")!
        
        // When
        cacheManager.saveImage(testImageData, for: testURL)
        URLCache.shared.removeAllCachedResponses()
        let cachedImage = cacheManager.getImage(for: testURL)
        
        // Then
        guard cachedImage == nil else {
            throw ImageCacheError.retrievalFailed("Image should not exist after cache clearing")
        }
    }
    
    // Test 5: Concurrent cache access
    @Test func testConcurrentCacheAccess() async throws {
        // Given
        let cacheManager = ImageCacheManager.shared
        URLCache.shared.removeAllCachedResponses()
        
        let testImageData = await createTestImageData()
        guard let testImageData else {
            throw ImageCacheError.failedToCreateTestData
        }
        
        let testURL = URL(string: "https://example.com/concurrent-test.jpg")!
        
        // When
        await withTaskGroup(of: Void.self) { group in
            group.addTask { cacheManager.saveImage(testImageData, for: testURL) }
            group.addTask { cacheManager.saveImage(testImageData, for: testURL) }
            group.addTask { _ = cacheManager.getImage(for: testURL) }
            group.addTask { _ = cacheManager.getImage(for: testURL) }
        }
        
        // Then
        let finalResult = cacheManager.getImage(for: testURL)
        guard finalResult != nil else {
            throw ImageCacheError.retrievalFailed("Final retrieval should succeed after concurrent operations")
        }
    }
    
    // Helper function to create test image data on main actor
    @MainActor
    private func createTestImageData() async -> Data? {
        let testImage = Image(systemName: "star.fill")
        let renderer = ImageRenderer(content: testImage)
        return renderer.uiImage?.pngData()
    }
}

