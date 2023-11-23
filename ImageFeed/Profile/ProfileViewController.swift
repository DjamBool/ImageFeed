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

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol { get set }
    var profileImageView: UIImageView {get set}
    var nameLabel: UILabel {get set}
    var loginNameLabel: UILabel {get set}
    var descriptionLabel: UILabel {get set}
    func updateProfileDetails()
    func logout()
    func showExitConfirmation()
    func clean()
}

class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol = {
        return ProfileViewPresenter()
    }()
    private let profileService = ProfileService.shared
    private var profile : Profile?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var profileImageView: UIImageView = {
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
    
    var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        nameLabel.font = UIFont(name: "HelveticaNeue-Bold" , size: 23)
        return nameLabel
    }()
    
    var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.systemGray4
        loginNameLabel.font = UIFont(name: "SF Pro" , size: 13)
        return loginNameLabel
    }()
    
    var descriptionLabel: UILabel = {
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
        presenter.view = self
        presenter.viewDidLoad()
        layout()
        updateProfileDetails()
    }
    
    @objc func didTapButton() {
        showExitConfirmation()
    }
    
    func updateProfileDetails() {
        presenter.updateProfileDetails(profile: profile)
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
        let alert = presenter.showExitConfirmation()
        present(alert, animated: true, completion: nil)
    }
    
    func logout() {
        KeychainWrapper.standard.removeAllKeys()
        clean()
        tabBarController?.dismiss(animated: true)
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration") }
        window.rootViewController = SplashViewController()
    }
}
