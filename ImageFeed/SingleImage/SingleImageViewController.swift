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
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    @IBAction func didTapBackButton(_ sender: UIButton, forEvent event: UIEvent) {
        dismiss(animated: true, completion: nil)
    }
    
}
