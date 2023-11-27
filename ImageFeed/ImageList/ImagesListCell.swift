
import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImagesListCellDelegate? 
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet  weak var cellImage: UIImageView!
    @IBOutlet  weak var likeButton: UIButton!
    @IBOutlet  weak var gradientView: UIView!
    @IBOutlet  weak var dateLabel: UILabel!
    private var photos = [Photo]()
    
    private let likeButtonOn = "like_button_on"
    private let likeButtonOf = "like_button_off"
    
    override func layoutSubviews() {
        super.layoutSubviews()
      //  makeGradient()
    }
    
    @IBAction func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func setIsLiked(isLiked: Bool) {
        let like = isLiked ? UIImage(named: likeButtonOn) : UIImage(named: likeButtonOf)
        likeButton.imageView?.image = like
        likeButton.setImage(like, for: .normal)
    }
}
