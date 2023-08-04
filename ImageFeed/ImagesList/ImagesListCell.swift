//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.08.23.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var dateLabel: UILabel!
    
}
