//
//  GenerateThumbnailOperationTests.swift
//  PlaylistPlayerTests
//
//  Created by Andy Brown on 01/03/2021.
//

import XCTest
@testable import Zoetrope

final class GenerateThumbnailOperationTests: XCTestCase {

    // MARK: - Properties and Setup

    let testURL = URL(string: "my/test/url")!
    var mockThumbnailGenerator: MockThumbnailGenerator!

    override func setUp() {
        super.setUp()

        mockThumbnailGenerator = MockThumbnailGenerator()
    }

    // MARK: - Tests

    func test_whenThumbnailGeneratorReturnsAnImage_OperationReturnsTheImage() {
        let testImage = createTestImage()
        mockThumbnailGenerator.thumbnailToReturn = testImage
        let sut = makeSUT()
        let operationQueue = OperationQueue()
        operationQueue.addOperation(sut)

        sut.onComplete = { image in
            XCTAssertEqual(image, testImage)
        }
    }

    func test_whenThumbnailGeneratorNil_OperationReturnsNil() {
        mockThumbnailGenerator.thumbnailToReturn = nil
        let sut = makeSUT()
        let operationQueue = OperationQueue()
        operationQueue.addOperation(sut)

        sut.onComplete = { image in
            XCTAssertNil(image)
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> GenerateThumbnailOperation {
        GenerateThumbnailOperation(thumbnailGenerator: mockThumbnailGenerator, url: testURL)
    }

    private func createTestImage() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        UIGraphicsBeginImageContext(rect.size)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
