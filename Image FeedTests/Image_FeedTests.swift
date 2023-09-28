//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Almira Khafizova on 28.09.23.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        print(service.photos.count)
        print(service.photos)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}

//error 401 unauthorised
