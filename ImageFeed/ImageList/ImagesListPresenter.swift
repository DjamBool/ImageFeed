//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 22.11.2023.
//

import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    func viewDidLoad()
    func viewDidDisappear()
    //func updateTableViewAnimated()
}

class ImagesListPresenter: ImagesListPresenterProtocol {
 
    
    var photos = [Photo]()
    var photosCount: Int {
        photos.count
    }
    
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        setImagesListServiceObserver()
        view?.configTableView()
    }
    
    func setImagesListServiceObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        imagesListService.fetchPhotosNextPage()
    }
    
    func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self,
                                                  name: ImagesListService.DidChangeNotification,
                                                  object: nil)
    }
    
//    func updateTableViewAnimated() {
//        let oldCount = photos.count
//        let newCount = imagesListService.photos.count
//        photos = imagesListService.photos
//        if oldCount != newCount {
//            var indexPaths = [IndexPath]()
//            view?.tableView.performBatchUpdates {
//                indexPaths = (oldCount..<newCount).map { i in
//                    IndexPath(row: i, section: 0)
//                }
//                view?.tableView.insertRows(at: indexPaths, with: .automatic)
//            } completion: { _ in }
//        }
//      //  view?.updateTableViewAnimated()
//   }
}
