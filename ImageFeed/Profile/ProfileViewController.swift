//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 08.09.2023.
//

import UIKit
import Kingfisher
import WebKit
import SwiftKeychainWrapper

class ProfileViewController: UIViewController {
    
    private let storageToken = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private var profile : Profile?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Userpick")
        return view
    }()
    
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: (UIImage(named: "Exit"))!,
            target: self,
            action: #selector(Self.didTapButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold" , size: 23)
        return nameLabel
    }()
    
    private let loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.systemGray4
        loginNameLabel.font = UIFont(name: "SF Pro" , size: 13)
        return loginNameLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        descriptionLabel.font = UIFont(name: "SF Pro" , size: 13)
        return descriptionLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        
        updateProfileDetails(profile: profile)
        layout()
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
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                                     options: [.processor(processor)])
    }
    
    @objc func didTapButton() {
        showExitConfirmation()
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            // profileImageView
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 52),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            
            // logoutButton
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 76),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            
            // nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.widthAnchor.constraint(equalToConstant: 241),
            
            //loginNameLabel
            loginNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.heightAnchor.constraint(equalToConstant: 18),
            loginNameLabel.widthAnchor.constraint(equalToConstant: 241),
            
            //descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 241)
        ])
    }
}
extension ProfileViewController {
    private func updateProfileDetails(profile: Profile?) {
        guard let profile = profileService.profile else {return}
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

extension ProfileViewController {
    func clean() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

extension ProfileViewController {
    func showExitConfirmation() {
        let alert = UIAlertController(title: "Пока, пока!",
                                      message: "Уверены, что хотите выйти?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) {[weak self] _ in
            guard let self = self else { return }
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        KeychainWrapper.standard.removeAllKeys()
        clean()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
