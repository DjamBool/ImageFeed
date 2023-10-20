
import Foundation

//extension URLRequest {
//    static func makeHTTPRequest(
//        path: String,
//        httpMethod: String,
//        baseURL: URL = defaultBaseURL
//    ) -> URLRequest {
//
//        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
//        request.httpMethod = httpMethod
//
//        if let token = OAuth2TokenStorage.shared.token {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        return request
//    }
//}

final class URLRequestBuilder {
    
    static let shared = URLRequestBuilder()
    private let storage: OAuth2TokenStorage
    
    init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
    
    func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = defaultBaseURL
    ) -> URLRequest {
        
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        
        if let token = storage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
