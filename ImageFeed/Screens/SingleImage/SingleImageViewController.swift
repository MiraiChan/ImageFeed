//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 15.08.23.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    private var alertPresenter: AlertPresenterProtocol?
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            guard let image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    var largeImageURL: URL?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.accessibilityIdentifier = "BackButton"
        
        view.backgroundColor = .ypBlack
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        imageView.image = image
        downloadImage()
        guard let image else { return }
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton, forEvent event: UIEvent) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let imageToShare = [ image ]
        let shareViewController = UIActivityViewController(
            activityItems: imageToShare,
            applicationActivities: nil)
        shareViewController.popoverPresentationController?.sourceView = self.view
        shareViewController.isModalInPresentation = true
        self.present(shareViewController, animated: true)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        UIView.animate(withDuration: 0.6) {
            if let image = self.image {
                self.rescaleAndCenterImageInScrollView(image: image)
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let scaleHeight = visibleRectSize.height / imageSize.height
        let scaleWidth = visibleRectSize.width / imageSize.width
        let scale = min(maxZoomScale, max(minZoomScale, max(scaleHeight, scaleWidth)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func downloadImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                showError()
            }
        }
    }
    
    func showError() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alertModel = AlertModel(
                title: "Что-то пошло не так",
                message: "Попробовать ещё раз?",
                buttonText: "Не надо",
                completion: { self.dismiss(animated: true) },
                secondButtonText: "Повторить",
                secondCompletion: { self.downloadImage() }
            )
            self.alertPresenter?.showAlert(for: alertModel)
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
