//
//  ViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 27.07.23.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    //чтобы открывалась нужная нам картинка:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //проверяем идентификатор сегвея, поскольку может быть больше одного сегвея, выходящего из нашего контроллера:
        if segue.identifier == ShowSingleImageSegueIdentifier {
            //делаем преобразования типа для свойства segue.destination, мы переходим  из таблицы к SingleImageViewController — поэтому такое преобразование типа безопасно. Если окажется, что мы выбрали неправильный сегвей или не настроили его надлежащим образом, то код в данной строчке закрэшится. Мы сразу же узнаем о проблеме и сможем быстро её исправить:
            let viewController = segue.destination as! SingleImageViewController
            //Делаем преобразование типа для аргумента sender (мы ожидаем, что там будет indexPath). Более того: мы не сможем сконфигурировать переход верно, если там окажется что-то другое:
            let indexPath = sender as! IndexPath
            //получаем по индексу название картинки и саму картинку из ресурсов приложения:
            let image = UIImage(named: photosName[indexPath.row])
            //передаём эту картинку в imageView внутри SingleImageViewController:
            viewController.image = image
        } else {
            //если это неизвестный сегвей, есть вероятность, что он был определён суперклассом (то есть родительским классом). В таком случае мы должны передать ему управление:
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.setGradientBackground()
        
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        
        cell.likeButton.setImage(likeImage, for: .normal)
        cell.likeButton.setTitle("", for: .normal)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //для осуществления перехода нам нужно выполнить
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}




