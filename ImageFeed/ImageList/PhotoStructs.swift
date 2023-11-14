//
//  PhotoStructs.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 09.11.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String?
    let width: CGFloat
    let height: CGFloat
    let color: String
    let blurHash: String
    let likes: Int
    let likedByUser: Bool?
    let description: String?
    let user: UserResult
    let urls: UrlsResult?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
        
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String?
    let regular: String
    let small: String
    let thumb: String?
}

struct Photo {
    let id: String
    let size: CGSize
    //    let width: CGFloat
    //    let height: CGFloat
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    var isLiked: Bool
} 

struct PhotoLikeResponse: Decodable {
    let photo: PhotoResult?
}
