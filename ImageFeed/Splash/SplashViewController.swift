//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Даниил Романов on 04.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        
        setupViews()
        
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func setupViews() {
        let splashLogoView = UIImageView(image: UIImage(named: "splash_screen_logo")!)
        
        splashLogoView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(splashLogoView)
        
        NSLayoutConstraint.activate([
            splashLogoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Failed to instantiate AuthViewController")
            return
        }
        
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        
        present(authViewController, animated: true, completion: nil)
    }
    
    private func switchToBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else {
                return
            }
 
            switch result {
            case .success(let profile):
                self.switchToBarController()
                
                profileImageService.fetchProfileImageURL(token: token, username: profile.username) { _ in
                }
            case .failure(let error):
                print("Ошибка получения профиля \(error.localizedDescription)")
                break
            }
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token)
    }
}
