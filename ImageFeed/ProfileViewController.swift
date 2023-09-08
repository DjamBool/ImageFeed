//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 08.09.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var profileNameLabel: UILabel!
    @IBOutlet private var profileEmailLabel: UILabel!
    @IBOutlet private var profileStatusLabel: UILabel!
    @IBOutlet private var exitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction private func exitButtonAction(_ sender: Any) {
        
    }
}
