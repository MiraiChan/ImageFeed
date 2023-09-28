//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.08.23.

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
  func imagesListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    private let placeholderImage = UIImage(named: "stub")
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func loadCell(from photo: Photo) -> Bool {
        var status = false
        
        if let photoDate = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: photoDate)
            
        }
    }
    
    func setGradientBackground() {
        
        gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let colorTop =  UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.0).cgColor
        let colorBottom = UIColor(red: 0.1/255.0, green: 0.11/255.0, blue: 0.13/255.0, alpha: 0.2).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.gradientView.bounds
        
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)
        cellImage.addSubview(gradientView)
    }
}
