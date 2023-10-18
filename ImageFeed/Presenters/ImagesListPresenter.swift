//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 17.10.23.
//

import Foundation
import Kingfisher

public protocol ImagesListPresenterProtocol {
  var view: ImagesListViewControllerProtocol? { get set }
  var photosTotalCount: Int { get }
  func viewDidLoad()
  func updateTableViewAnimated()
  func calculateHeight(indexPath: IndexPath) -> CGFloat
  func photosPerPageChecker(indexPath: IndexPath)
  func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
  func getPhotoStructure(indexPath: IndexPath) -> Photo?
}

final class ImagesListPresenter {
    
}
