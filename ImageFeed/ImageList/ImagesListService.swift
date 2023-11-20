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
                                   baseURL: DefaultBaseURL)
    }
    
    func convert(result: PhotoResult) -> Photo {
        let photo = Photo(id: result.id,
                          size: CGSize(width: result.width, height: result.height),
                          createdAt: self.dateFormatter.date(from: result.createdAt),
                          welcomeDescription: result.description,
                          thumbImageURL: result.urls?.thumb,
                          largeImageURL: result.urls?.full,
                          isLiked: result.likedByUser ?? false)
        return photo
    }
}

extension ImagesListService {
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        task? .cancel()
        guard let request = fetchLikeRequest(photoId: photoId, isLike: isLike) else {
            assertionFailure("Invalid like request")
            return
        }
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoLikeResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.task = nil
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    self.photos[index].isLiked = (response.photo?.likedByUser)!
                }
                completion(.success(()))
            case .failure(let error):
                print("Fetch Like Error - \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func fetchLikeRequest(photoId: String, isLike: Bool) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "photos/\(photoId)/like",
                                   httpMethod: isLike ? "POST" : "DELETE",
                                   baseURL: DefaultBaseURL)
    }
}
