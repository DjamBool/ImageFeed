//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 04.11.2023.
//

import Foundation

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    static let shared = ProfileImageService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeRequest(userName: username) else { return }
        task = urlSession.objectTask(for: request, completion: { [weak self ] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profiePhoto):
                guard let smallPhoto = profiePhoto.profileImage?.small else { return }
                self.avatarURL = smallPhoto
                completion(.success(smallPhoto))
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": smallPhoto]
                )
                
            case .failure(let error):
                completion(.failure(error))
            }
        })
        task?.resume()
    }
    
    private func makeRequest(userName: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/users/\(userName)",
                                   httpMethod:"GET",
                                   baseURL: URL(string: defaultApiBaseURL)!
        )
    }
}
