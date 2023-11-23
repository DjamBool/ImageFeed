//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 20.11.2023.
//

import Foundation
import WebKit
import Kingfisher

protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func showExitConfirmation() -> UIAlertController
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private let profileImageService = ProfileImageService.shared
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storageToken = OAuth2TokenStorage.shared
    var profile: Profile?
    
    func viewDidLoad() {
       // updateProfileDetails(profile: profile)
        updateAvatar()
        observeNotification()
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else {return}
        view?.nameLabel.text = profile.name
        view?.loginNameLabel.text = profile.loginName
        view?.descriptionLabel.text = profile.bio
    }
    
    func observeNotification() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        view?.profileImageView.kf.indicatorType = .activity
        view?.profileImageView.kf.setImage(with: url,
                                           options: [.processor(processor)])
    }
    
    func showExitConfirmation() -> UIAlertController {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            view?.logout()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
}
