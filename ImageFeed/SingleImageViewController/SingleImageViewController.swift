
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var imageURL: URL? {
        didSet {
            guard isViewLoaded else { return }
            //imageView.image = imageURL
           // rescaleAndCenterImageInScrollView(image: imageURL)
            setImage()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // imageView.image = imageURL
        //rescaleAndCenterImageInScrollView(image: imageURL)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        setImage()
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton() {
        let share = UIActivityViewController(
            activityItems: [imageURL as Any],
            applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("error")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - extension SingleImageViewController: UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

// MARK: - extension SingleImageViewController
extension SingleImageViewController {
    private func rescaleAndCenterImageInScrollView (image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
}
