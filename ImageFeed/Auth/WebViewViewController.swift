//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 25.09.2023.
//

import UIKit
import WebKit

private let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    weak var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        progressView.progressViewStyle = .bar
        
        loadWebView()
        
    }
// изменено с viewWillAppear на viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

// MARK: - extension WebViewViewController: WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            print("the function", #function, "worked")
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func fetchCode(url: URL?) -> String? {
    guard let url = url,
          let components = URLComponents(string: url.absoluteString),
          components.path == "/oauth/authorize/native",
          let codeItem = components.queryItems?.first(where: { $0.name == "code" })
        else { return nil }
        
        return codeItem.value
    }
}

// MARK: - extension WebViewViewController + func loadWebView()
private extension WebViewViewController {
    func loadWebView() {
        var components = URLComponents(string: unsplashAuthorizeURLString)
        components?.queryItems = [URLQueryItem(name: "client_id", value: accessKey),
                                  URLQueryItem(name: "redirect_uri", value: redirectURI),
                                  URLQueryItem(name: "response_type", value: "code"),
                                  URLQueryItem(name: "scope", value: accessScope)]
        if let url = components?.url {
            let request = URLRequest(url: url)
            webView.load(request)
            updateProgress()
        }
    }
}


