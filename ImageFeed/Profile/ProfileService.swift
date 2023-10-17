//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 16.10.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private (set) var profile: Profile?
    
    private var task: URLSessionTask?
    private var urlSession = URLSession.shared
    
    private enum NetworkError: Error {
        case codeError
    }
    
    
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
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
            self.name = profileResult.firstName + " " + profileResult.lastName
            self.loginName = "@" + profileResult.username
            self.bio = profileResult.bio
        }
    }

    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        print("MyProfile")
        
        guard let url = URL(string: "https://api.unsplash.com/me") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                completion(Result.failure(error))
                print("Error fetchProfile()")
                return
            }
        }
        task?.resume()
    }
}

