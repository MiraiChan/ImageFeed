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
    
    private let session = URLSession.shared
    private let requestBuilder = URLRequestBuilder.shared
    private let imagesPerPage = 10
    
    private var currentTask: URLSessionTask?
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    
    private init() { }
    
    func makePhotosListRequest(page: Int) -> URLRequest? {
        requestBuilder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=\(imagesPerPage)"
        )
    }
    
    func makeNextPageNumber() -> Int {
        guard let lastLoadedPage else { return 1 }
        return lastLoadedPage + 1
    }
    
    func convert(result photoResult: PhotoResult) -> Photo {
        let thumbWidth = 200.0
        let aspectRatio = Double(photoResult.width) / Double(photoResult.height)
        let thumbHeight = thumbWidth / aspectRatio
        return Photo(
            id: photoResult.id,
            size: CGSize(width: Double(photoResult.width), height: Double(photoResult.height)),
            createdAt: ISO8601DateFormatter().date(from: photoResult.createdAt ?? ""),
            welcomeDescription: photoResult.description,
            thumbImageURL: photoResult.urls.small,
            largeImageURL: photoResult.urls.full,
            isLiked: photoResult.likedByUser,
            thumbSize: CGSize(width: thumbWidth, height: thumbHeight)
        )
    }
    
    func resetPhotos() {
        photos = []
    }
    
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        
        guard currentTask == nil else {
            return
        }
        
        let nextPage = makeNextPageNumber()
        
        guard let request = makePhotosListRequest(page: nextPage) else {
            assertionFailure("Invalid request")
            print(NetworkError.invalidRequest)
            return
        }
        
        let task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { preconditionFailure("Cannot make weak link") }
            switch result {
            case .success(let photoResults):
                DispatchQueue.main.async {
                    var photos: [Photo] = []
                    photoResults.forEach { photo in
                        photos.append(self.convert(result: photo))
                    }
                    self.photos += photos
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self.lastLoadedPage = nextPage
                }
            case .failure(let error):
                print("\(String(describing: error))")
            }
            self.currentTask = nil
        }
        currentTask = task
        task.resume()
    }
}





