//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 04.10.2023.
//

import Foundation

class OAuth2Service {
   
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
    }
}

