
import Foundation

class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let storage: OAuth2TokenStorage
    private let builder: URLRequestBuilder
    private let urlSession: URLSession
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    init(urlSession: URLSession = .shared,
         storage: OAuth2TokenStorage = .shared,
         builder: URLRequestBuilder = .shared) {
        self.urlSession = urlSession
        self.storage = storage
        self.builder = builder
    }
    
    func fetchAuthToken(_ code: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard code != lastCode, currentTask != nil else { return }
//        if lastCode == code { return }
//        currentTask?.cancel()
        lastCode = code
        
        
        let request = authTokenRequest(code: code)
        currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
           self?.currentTask = nil
            switch response {
            case .success(let body):
                            let authToken = body.accessToken
                            self?.authToken = authToken
                            completion(.success(authToken))
                        case .failure(let error):
                            completion(.failure(error))
            }
        }
//        let task = object(for: request) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let body):
//                let authToken = body.accessToken
//                self.authToken = authToken
//                completion(.success(authToken))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        task.resume()
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        builder.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!)
    }
    
//    private func object(
//        for request: URLRequest,
//        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
//            let decoder = JSONDecoder()
//            return urlSession.objectTask(for: request) { (result: Result<Data, Error>) in
//                let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
//                    Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
//                }
//                completion(response)
//            }
//        }
    
//    func fetchOAuthBody(for request: URLRequest, completion: @escaping
//                        (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
//        let fulfillCompletionOnMainThread: (Result<OAuthTokenResponseBody, Error>) -> Void =
//        { result in
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
//                        let result = try decoder.decode(OAuthTokenResponseBody.self, from: data)
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
//    }
}


