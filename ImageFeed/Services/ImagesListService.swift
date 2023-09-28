//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 27.09.23.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        let nextPage = makeNextPageNumber()
        //lastLoadedPage == nil
        ? 1
        : lastLoadedPage!.number + 1
        
        // ...
    }
    
    func makeNextPageNumber() {
        
    }
}
