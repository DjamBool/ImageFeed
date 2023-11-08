
import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    //private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let oauth2Service = OAuth2Service.shared
    private var profile: Profile?
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private let logoName = "splash_screen_logo"
    private let authVCid = "AuthViewControllerID"
    
    private lazy var logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: logoName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        view.backgroundColor = UIColor(named: "YP Black")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            fetchProfile(token: token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: authVCid)
                    as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func layout(){
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 77.68),
            logoImageView.widthAnchor.constraint(equalToConstant: 75)
        ])
    }
}

// MARK: - Segue Preparation
extension SplashViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
}

// MARK: - extension SplashViewController: AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            //UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchAuthToken(code) { [weak self] authResult in
            guard let self = self else { return }
            switch authResult {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                self.showAlert(error: error)
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] profileResult  in
            guard let self = self else { return }
            switch profileResult {
            case .success: //(let profile):
                //UIBlockingProgressHUD.dismiss()
                // self.profile = profile
                //self.fetchProfileImageURL()
                
                //добавлено для аватар урл:
                if let userName = self.profileService.profile?.username {
                    fetchProfileImageURL(username: userName)
                    //                    self.profileImageService.fetchProfileImageURL(username: userName) { result in
                    //                        switch result {
                    //                        case .success(let imageUrl):
                    //                            print("Avatar URL: \(imageUrl)")
                    //                        case .failure(let error):
                    //                            print("error - \(error)")
                    //                        }
                    //                    }
                    //конец
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.showAlert(error: error)
                break
            }
        }
    }
    private func fetchProfileImageURL(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            switch result {
            case .success(let imageUrl):
                print("Avatar URL: \(imageUrl)")
            case .failure(let error):
                print("error - \(error)")
                self.showAlert(error: error)
            }
        }
    }
    
    private func showAlert(error: Error) {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
