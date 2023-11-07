
import Foundation

final class ProfileService {
    
    static let shared = ProfileService()
    private (set) var profile: Profile?

    private let urlSession = URLSession.shared
    private var lastToken: String?
    private var currentTask: URLSessionTask?

    func fetchProfile(_ token: String,
                      completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        currentTask?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(token: token) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        
        currentTask = urlSession.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            self.currentTask = nil
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
    
    private func makeProfileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me",
                                   httpMethod:"GET",
                                   baseURL: URL(string: defaultApiBaseURL)!
        )
    }
    }

