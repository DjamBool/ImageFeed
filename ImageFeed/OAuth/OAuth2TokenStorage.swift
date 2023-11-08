
import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "BearerToken"
    
    let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: tokenKey)
            
        }
        set {
            guard let newValue = newValue  else { return }
            keychainWrapper.set(newValue, forKey: tokenKey)
        }
    }
}
