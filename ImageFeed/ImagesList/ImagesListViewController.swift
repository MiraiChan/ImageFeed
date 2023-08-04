//
//  ViewController.swift
//  ImageFeed
//
//  Created by Almira Khafizova on 27.07.23.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    //метод, который определяет количество ячеек в секции таблицы, возврат значения. Так как в проекте секция у нас всего одна, проигнорируем значение параметра section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //метод протокола должен возвращать ячейку. У класса UITableViewCell есть дефолтный конструктор, который не принимает никаких аргументов.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Метод, который из всех ячеек, зарегистрированных в таблице, возвращает ячейку по заранее добавленному идентификатору:
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        //Чтобы работать с ячейкой как с экземпляром класса ImagesListCell, нам надо провести приведение типов:
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
            //при неуспешной кастомизации ячейки к нужному типу приложение можно аварийно завершить или прологгировать ошибку создания
        }
        
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell // 4
    }
    
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) { }
}


extension ImagesListViewController: UITableViewDelegate {
    //Этот метод отвечает за действия, которые будут выполнены при тапе по ячейке таблицы. «Адрес» ячейки, который содержится в indexPath, передаётся в качестве аргумента.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}



