//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 17.10.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastUserName: String?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    struct UserResult: Codable {
        let profileImage: SmallImageURL
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct SmallImageURL: Codable {
        let small: String
    }
    
    func fetchProfileImageURL(username: String,
                              _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUserName == username { return }
        task?.cancel()
        lastUserName = username
        
        let request = makeRequest(username: username)
        task = object(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                if let avatarURL = self.avatarURL {
                    completion(.success(avatarURL))
                    print("1avatarURL:", avatarURL)
                return
                }
                self.avatarURL = userResult.profileImage.small
                completion(.success(userResult.profileImage.small))
                let profileImageURL = ProfileImageService.shared.avatarURL
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.DidChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL!])
                
                print("2avatarURL: \(String(describing: self.avatarURL))")
                print("profileImageURL = \(String(describing: profileImageURL))")
            case .failure(let error):
                completion(.failure(error))
            }
            self.task?.resume()
        }
                
    }
}

extension ProfileImageService {
        
    private enum NetworkError: Error {
        case codeError
    }
    
    private func makeRequest(username: String) -> URLRequest {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            fatalError("Failed to create Avatar URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let token = OAuth2TokenStorage.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<UserResult, Error>) -> Void) -> URLSessionTask {
            let decoder = JSONDecoder()
            return urlSession.data(for: request) { (result: Result<Data, Error>) in
                let response = result.flatMap { data -> Result<UserResult, Error> in
                    Result { try decoder.decode(UserResult.self, from: data) }
                }
                completion(response)
            }
        }
}



