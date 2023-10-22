//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 16.10.2023.
//

import Foundation

final class ProfileService {
 
    struct ProfileResult: Codable {
        let username: String
        let firstName: String?
        let lastName: String?
        let bio: String?
        
        enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct Profile: Codable {
        let username: String
        let name: String
        let loginName: String
        let bio: String?
        
        init(profileResult: ProfileResult) {
            self.username = profileResult.username
            self.name = (profileResult.firstName ?? "") + " " + (profileResult.lastName ?? "")
            self.loginName = "@" + profileResult.username
            self.bio = profileResult.bio
        }
    }
    
    static let shared = ProfileService()
    private (set) var profile: Profile?
    private let requestBuilder: URLRequestBuilder
    
    private var task: URLSessionTask?
    private var urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    
    
    init(requestBuilder: URLRequestBuilder = .shared) {
        self.requestBuilder = requestBuilder
    }
//    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
//        assert(Thread.isMainThread)
//
//        let request = makeProfileRequest(token: token)
//        let task = object(for: request) { (result: Result<ProfileResult, Error>) in
//            switch result {
//            case .success(let body):
//                let profile = Profile(profileResult: body)
//                self.profile = profile
//                completion(.success(profile))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        self.task = task
//        task.resume()
//    }
//}
//
//extension ProfileService {
//
//    private enum NetworkError: Error {
//        case codeError
//    }
//
//    private func makeProfileRequest(token: String) -> URLRequest {
//        guard let url = URL(string: "https://api.unsplash.com/me") else { fatalError("Failed URL")}
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        if let token = OAuth2TokenStorage.shared.token {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        return request
//    }
//
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
//            let decoder = JSONDecoder()
//            return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
//                let response = result.flatMap { data -> Result<ProfileResult, Error> in
//                    Result { try decoder.decode(ProfileResult.self, from: data) }
//                }
//                completion(response)
//            }
//        }
    
    func fetchProfile(_ token: String,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        currentTask?.cancel()
        
        guard let request = fetchProfileRequest(token: token) else {
            assertionFailure("Invalid fetchProfileRequest()")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            self?.currentTask = nil
            switch response {
            case .success(let body):
                let profile = Profile(profileResult: body)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchProfileRequest(token: String) -> URLRequest? {
        requestBuilder.makeHTTPRequest(path: "/me",
                                   httpMethod: "GET",
                                   baseURL: defaultBaseURL)
    }
    
//    func fetch(request: URLRequest,
//completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
//        let fulfillCompletionOnMainThread: (Result<ProfileResult, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                if 200 ..< 300 ~= statusCode {
//                    do {
//                        let decoder = JSONDecoder()
//                        let result = try decoder.decode(ProfileResult.self, from: data)
//                        fulfillCompletionOnMainThread(.success(result))
//                    } catch {
//                        fulfillCompletionOnMainThread(.failure(error))
//                    }
//                } else {
//                    fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//            } else if let error = error {
//                fulfillCompletionOnMainThread(.failure(error))
//            } else {
//                fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
//            }
//        })
//        task.resume()
//        return task
//}
}
