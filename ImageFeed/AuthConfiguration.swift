
import Foundation

let AccessKey = "C7KQQn0EnC0wMO2JkCbuThc7rjLpxxuM49mgg-GSPXQ"
let SecretKey = "YZGi5nJD7kvm7UIs_Fa8F3h4KnbFPUtyy1qDiO5g8G8"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"

let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let baseURLString = "https://unsplash.com"
let defaultApiBaseURL = "https://api.unsplash.com"

let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

let bearerToken = "bearerToken"

struct AuthConfiguration {
    let accessKey: String
        let secretKey: String
        let redirectURI: String
        let accessScope: String
        let defaultBaseURL: URL
        let authURLString: String
        
        init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.redirectURI = redirectURI
            self.accessScope = accessScope
            self.defaultBaseURL = defaultBaseURL
            self.authURLString = authURLString
        }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 authURLString: unsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
}
