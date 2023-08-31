//
//  ViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 28.08.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    let listOfImageNames = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
    
    guard let imageListCell = cell as? ImagesListCell else {
    
        return UITableViewCell()
    }
    configCell(for: imageListCell)
    return imageListCell
}


}
//extension ImagesListViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //return 1
//        return listOfImageNames.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
//
////        let image = UIImage(named: listOfImageNames[indexPath.row])
////        cell.imageView?.image = image
//        guard let imageListCell = cell as? ImagesListCell else {
//            return UITableViewCell()
//        }
//
//        configCell(for: imageListCell)
//
//        return imageListCell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let imageHeight: CGFloat = 150
//
//        return imageHeight
//
//    }
//}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell) { }
}
