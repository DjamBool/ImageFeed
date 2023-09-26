//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 26.09.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    // WebViewViewController получил код.
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    // пользователь нажал кнопку назад и отменил авторизацию
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}
