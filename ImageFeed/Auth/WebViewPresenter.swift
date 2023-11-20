//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 19.11.2023.
//

import Foundation
import UIKit

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
            self.authHelper = authHelper
        }
    
    func viewDidLoad() {
//        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
//        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: AccessKey),
//                                  URLQueryItem(name: "redirect_uri", value: RedirectURI),
//                                  URLQueryItem(name: "response_type", value: "code"),
//                                  URLQueryItem(name: "scope", value: AccessScope)]
//        let url = urlComponents.url!
//        let request = URLRequest(url: url)
//        
//        didUpdateProgressValue(0)
//        
//        view?.load(request: request)
        let request = authHelper.authRequest()
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
           abs(value - 1.0) <= 0.0001
       }
    
    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
        authHelper.code(from: url)
    }
}
