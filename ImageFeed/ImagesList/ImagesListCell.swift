//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 04.08.23.
/* Привет! Спасибо за проверку. Вопросы:
 1) Я удалила Accent Color и теперь вылезает это предупреждение , котoрое немного напрягает. Что делать?
 2) Как лучше раскидать файлы оставшиеся файлы по папкам и нужно ли?
 */
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    func setGradientBackground() {
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
