//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 09.11.2023.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage: Int?    //хранить номер последней скачанной страницы
    private (set) var photos: [Photo] = []  //Хранить список уже скачанных фотографий
    private var photo: Photo?
    let perPage = 10
    private let dateFormatter = ISO8601DateFormatter()
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
//        guard let token = OAuth2TokenStorage.shared.token else {
//            print("there is no token for the makePhotolistRequest")
//            return
//        }
        guard let request = makePhotolistRequest(page: nextPage) else {
            assertionFailure("Invalid request for fetchPhotosNextPage")
            return
        }
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self]
            (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let photoResult):
                    for photo in photoResult {
                        self.photos.append(self.convert(result: photo))
                    }
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(name: ImagesListService.DidChangeNotification,
                              object: self)
//
                case .failure(let error):
                    assertionFailure("Failed to fetch photos, \(error)")
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makePhotolistRequest(page: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/photos?page=\(page)&&per_page=\(perPage)",
                                   httpMethod: "GET",
                                   baseURL: defaultBaseURL)
    }
    
    private func dateFormatter(_ date: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: date)
    }
    
    func convert(result: PhotoResult) -> Photo {
        //let photo = Photo.init(...)
        let photo = Photo(id: result.id,
                               size: CGSize(width: result.width, height: result.height), createdAt: dateFormatter(result.createdAt), welcomeDescription: result.description, thumbImageURL: result.urls?.thumb, largeImageURL: result.urls?.full, isLiked: result.likedByUser ?? false)
        return photo
    }
}
