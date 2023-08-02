//
//  ViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 27.07.23.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ImagesListViewController: UITableViewDataSource {
    //метод, который определяет количество ячеек в секции таблицы, возврат значения. Так как в проекте секция у нас всего одна, проигнорируем значение параметра section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //метод протокола должен возвращать ячейку. У класса UITableViewCell есть дефолтный конструктор, который не принимает никаких аргументов.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}


extension ImagesListViewController: UITableViewDelegate {
    //Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы. «Адрес» ячейки, который содержится в indexPath, передаётся в качестве аргумента.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}

