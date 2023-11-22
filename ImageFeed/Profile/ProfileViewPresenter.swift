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
    // func updateProfileDetails(profile: Profile?)
    func updateAvatar()
    //func setDetails()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    private let profileImageService = ProfileImageService.shared
    var profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storageToken = OAuth2TokenStorage.shared
    var profile: Profile?
    
    func viewDidLoad() {
        //setDetails()
        updateProfileDetails(profile: profile)
        updateAvatar()
        observeNotification()
    }
    
//    func setDetails() {
//        guard let profile = profileService.profile else {
//            assertionFailure("setDetails is failed")
//            return
//        }
//        view?.updateProfileDetails(profile: profile)
//    }
//    
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
}
