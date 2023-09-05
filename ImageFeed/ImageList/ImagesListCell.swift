//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Игорь Мунгалов on 04.09.2023.
//

import UIKit
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeGradient()
    }
    
    private func makeGradient() {
        let gradient = CAGradientLayer()
        let colorStart = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1).cgColor
        let colorFinish = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.0107615894).cgColor
        
        gradient.colors = [colorStart, colorFinish]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.3, y: 0.5)
        gradient.frame = gradientView.bounds
        gradient.opacity = 0.1
        
        cellImage.addSubview(gradientView)
        gradientView.layer.addSublayer(gradient)
        dateLabel.layer.opacity = 0.9
    }
}
