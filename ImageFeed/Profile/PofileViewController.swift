//
//  PofileViewController.swift
//  ImageFeed
//
//  Created by Даниил Романов on 21.05.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 26/255.0, green: 27/255.0, blue: 34/255.0, alpha: 1)
        
        setupViews()
        
        guard let profile = profileService.profile else {
            return
        }
        
        updateProfileDetails(profile: profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                
                guard let self else {
                    return
                }
                
                self.updateAvatar()
            }
        
        
        updateAvatar()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        
        avatarImageView?.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView?.kf.setImage(with: url, options: [.processor(processor)])
    }
    
    private func setupViews() {
        layoutAvatarImageView()
        layoutNameLabel()
        layoutLoginNameLabel()
        layoutDescriptionLabel()
        layoutLogoutButton()
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func layoutAvatarImageView() {
        let avatarImageView = UIImageView(image: UIImage(named: "Photo")!)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.avatarImageView = avatarImageView
        
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
        avatarImageView.widthAnchor.constraint(equalToConstant: 70),
        avatarImageView.heightAnchor.constraint(equalToConstant: 70),
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
        avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func layoutNameLabel() {
        guard let avatarImageView = avatarImageView else { return }
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.nameLabel = nameLabel
        
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func layoutLoginNameLabel() {
        guard let nameLabel = nameLabel, let avatarImageView = avatarImageView else { return }
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .gray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.loginNameLabel = loginNameLabel
        
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
        loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func layoutDescriptionLabel() {
        guard let loginNameLabel = loginNameLabel, let avatarImageView = avatarImageView else { return }
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .white
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.descriptionLabel = descriptionLabel
        
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
        descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func layoutLogoutButton() {
        guard let avatarImageView = avatarImageView else { return }
        
        let logoutButton = UIButton.systemButton(with: UIImage(named: "Exit")!, target: self, action: #selector(didTapLogoutButton))
        logoutButton.tintColor = UIColor(red: 245/255.0, green: 107/255.0, blue: 108/255.0, alpha: 1)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.logoutButton = logoutButton
        
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
        logoutButton.widthAnchor.constraint(equalToConstant: 24),
        logoutButton.heightAnchor.constraint(equalToConstant: 24),
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc
    private func didTapLogoutButton() {
    }
}
