//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 27.09.23.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage!.number + 1
        
        // ...
    }
}
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
