//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 25.09.2023.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
  
    var presenter: WebViewPresenterProtocol?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
  //  private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progressViewStyle = .bar
        webView.navigationDelegate = self
        //loadWebView()
        presenter?.viewDidLoad()
        
//        estimatedProgressObservation = webView.observe(
//            \.estimatedProgress,
//             options: [],
//             changeHandler: { [weak self] _, _ in
//                 guard let self = self else { return }
//                 // self.updateProgress()
//             })
    }
    
    //    private func updateProgress() {
    //        progressView.progress = Float(webView.estimatedProgress)
    //        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    //    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    override func observeValue(forKeyPath keyPath: String?, 
                               of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - extension WebViewViewController: WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) { //fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
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

/*
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
            // updateProgress()
        }
    }
}
*/

