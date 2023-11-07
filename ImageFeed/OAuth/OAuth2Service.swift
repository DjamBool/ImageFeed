
import Foundation

class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let storage: OAuth2TokenStorage
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
         storage: OAuth2TokenStorage = .shared) {
        self.urlSession = urlSession
        self.storage = storage
    }
    
    func fetchAuthToken(_ code: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
                currentTask?.cancel()
                lastCode = code
        
        let request = authTokenRequest(code: code)
        
        currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>)in
            self?.currentTask = nil
            guard let self = self else { return }
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self.storage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(accessKey)"
            + "&&client_secret=\(secretKey)"
            + "&&redirect_uri=\(redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!)
    }
}


