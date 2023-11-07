//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 25.09.2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        progressView.progressViewStyle = .bar
        loadWebView()
        
        estimatedProgressObservation = webView.observe(
                   \.estimatedProgress,
                   options: [],
                   changeHandler: { [weak self] _, _ in
                       guard let self = self else { return }
                       self.updateProgress()
                   })
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


