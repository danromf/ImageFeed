import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var exitButtonPressedCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func profileLogout() {
        exitButtonPressedCalled = true
    }
    
    func updateAvatarURL() {
    }
    
    func updateProfile() {
    }
}
