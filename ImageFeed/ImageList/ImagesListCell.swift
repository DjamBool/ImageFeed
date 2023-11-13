
import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet  weak var cellImage: UIImageView!
    @IBOutlet  weak var likeButton: UIButton!
    @IBOutlet  weak var gradientView: UIView!
    @IBOutlet  weak var dateLabel: UILabel!
    private var photos = [Photo]()
 
    var imageLoadCompletion: (() -> Void)?
    var imageLoadFailure: ((Error) -> Void)?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configCell(image: UIImage?, date: String, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = date
        
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
        
    }
     
    func newConfigCell(photo: Photo) {
        let url = URL(string: photo.largeImageURL!)
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url,
                              placeholder: UIImage(named: "blankImage")) { [self] result in
            switch result {
            case .success:
                self.imageLoadCompletion?()
                print("blankIMG")
            case .failure(let error):
                self.imageLoadFailure?(error)
            print("cell configuration error \(error)")
            }
        }
    }
}
