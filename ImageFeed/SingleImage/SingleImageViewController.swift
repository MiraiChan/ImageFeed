//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 15.08.23.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    //чтобы не крашился - научим SingleViewController показывать разные картинки, не инициируя загрузку view. Для этого мы добавим ему свойство image и будем инициализировать его. А уже после viewDidLoad оно будет проставлять переданный image в imageView:
    var image: UIImage! {
        //если нам нужно подменять изображение уже после viewDidLoad, мы можем реализовать обработчик didSet для image следующим образом:
        didSet {
            //Сначала мы проверяем, было ли ранее загружено view. Это очень важная проверка, необходимая, чтобы не закрэшиться, если view ещё не было загружено (и, соответственно, аутлет ещё не инициализирован). Именно эта проверка не даст нам закрэшиться из prepareForSegue:
            guard isViewLoaded else { return }
            //В эту точку мы не должны попадать из prepareForSegue. Мы можем попасть в неё, например, если был показан SingleImageViewController, а указатель на него был запомнен извне. Далее  — извне (например, по свайпу) в него проставляется новое изображение:
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            //кодом дробные значения, в сториборде int
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25//выбирать значение для зума больше 1.25 pt обычно не стоит.
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton, forEvent event: UIEvent) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image ?? <#default value#>],//defaultImage
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        //границы возможных значений зума для scrollView:
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()//форсирует пересчёт фреймов,так как scrollView.superview — это и есть view. Если этого не сделать, то scrollView.frame (и, как следствие, scrollView.bounds) будет содержать относительно случайное значение.
        let visibleRectSize = scrollView.bounds.size//формулa вычисления скейла
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width//для ширины (горизонтальной оси)
        let vScale = visibleRectSize.height / imageSize.height//для высоты (вертикальной оси)
        //чтобы изображение заняло всё доступное пространство, минимальный скейл должен равняться максимальному из двух значений выше:
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        //применяем вычисленный скейл к scrollView,но эта функцтя не меняет scrollView.contentSize мгновенно. Он лишь помечает, что данные лэйаута устарели, и что при следующей итерации лэйаута экрана значение scale будет считано и применено к содержимому:
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()//заставляет систему пересчитать размеры и позиции всех саб-вью этой вью (View) и применить новые значения фреймов ко всем саб-вью.
        let newContentSize = scrollView.contentSize//не обновится сразу
        //Чтобы спозиционировать картинку по центру скролл-вью, мы должны сместить так:
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)//нужно задать нашей картинке, чтобы центр увеличенного изображения совпал с центром экрана.
    }
}
//метод делегата, который сообщит ScrollView, какую именно View нужно увеличивать в момент зума
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
