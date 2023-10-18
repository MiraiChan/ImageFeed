//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 17.10.23.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var totalNumberOfPhotos: Int { get }
    
    func viewDidLoad()
    func updateTableViewAnimated()
    func calculateHeight(indexPath: IndexPath) -> CGFloat
    func photosPerPageChecker(indexPath: IndexPath)
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func getPhotoStructure(indexPath: IndexPath) -> Photo?
}

final class ImagesListPresenter {
    private var imagesListService = ImagesListService.shared
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var totalNumberOfPhotos: Int {
        photos.count
    }
    
    func setupImageListService() {
        imagesListService.fetchPhotosNextPage()
        updateTableViewAnimated()
    }
}

extension ImagesListPresenter: ImagesListPresenterProtocol {
    func viewDidLoad() {
        view?.setupTableView()
        setupImageListService()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        if oldCount != newCount {
            view?.tableView.performBatchUpdates {
                let indexes = (oldCount..<newCount).map { index in
                    IndexPath(row: index, section: 0)
                }
                view?.tableView.insertRows(at: indexes, with: .automatic)
            }
        }
    }
    
    func calculateHeight(indexPath: IndexPath) -> CGFloat {
        guard let view else { return 0 }
        let thumbImageSize = photos[indexPath.row].thumbSize
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = view.tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = thumbImageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = thumbImageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func photosPerPageChecker(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self ] result in
            guard let self else { return }
            switch result {
            case .success(let isLiked):
                self.photos[indexPath.row].isLiked = isLiked
                cell.setIsLiked(isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func getPhotoStructure(indexPath: IndexPath) -> Photo? {
        photos[indexPath.row]
    }
}
