//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 08.09.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    let profileImage = UIImage(named: "Userpick")
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let eMailLabel = UILabel()
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeProfileImage()
        makeNameLabel()
        makeEMailLabel()
        makeStatusLabel()
        layout()
    }
    
    func makeProfileImage() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = profileImage
        view.addSubview(profileImageView)
    }
    
    func makeNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        nameLabel.font = UIFont(name: "SF Pro" , size: 23)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        view.addSubview(nameLabel)
    }
    func makeEMailLabel() {
        eMailLabel.translatesAutoresizingMaskIntoConstraints = false
        eMailLabel.text = "@ekaterina_nov"
        eMailLabel.textColor = UIColor(named: "YP Gray") ?? UIColor.systemGray4
        eMailLabel.font = UIFont(name: "SF Pro" , size: 13)
        view.addSubview(eMailLabel)
    }
    func makeStatusLabel() {
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "Hello, world!"
        statusLabel.textColor = UIColor(named: "YP White") ?? UIColor.white
        statusLabel.font = UIFont(name: "SF Pro" , size: 13)
        view.addSubview(statusLabel)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            nameLabel.widthAnchor.constraint(equalToConstant: 241),
            
            eMailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            eMailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            eMailLabel.heightAnchor.constraint(equalToConstant: 18),
            eMailLabel.widthAnchor.constraint(equalToConstant: 241),

            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: eMailLabel.bottomAnchor, constant: 8),
            statusLabel.heightAnchor.constraint(equalToConstant: 18),
            statusLabel.widthAnchor.constraint(equalToConstant: 241)
        ])
    }
}
