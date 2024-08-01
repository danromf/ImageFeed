import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func profileLogout()
    func updateAvatarURL()
    func updateProfile()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    func viewDidLoad() {
        updateAvatarURL()
        
        if let avatarURL = profileImageService.avatarURL {
            view?.updateAvatar(avatarURL: avatarURL)
        }
        
        updateProfile()
    }
    
    func updateProfile() {
        guard let profile = profileService.profile else { return }
        view?.showProfile(profile: profile)
    }
    
    func profileLogout() {
        ProfileLogoutService.shared.logout()
        OAuth2TokenStorage.shared.token = nil
    }
    
    func updateAvatarURL() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard
                    let self = self,
                    let avatarURL = self.profileImageService.avatarURL else { return }
                view?.updateAvatar(avatarURL: avatarURL)
            }
    }
}
