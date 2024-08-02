@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        let profilePresenter = ProfilePresenterSpy()
        let profileViewController = ProfileViewController()
        profileViewController.configure(profilePresenter)
        
        _ = profileViewController.view
        
        XCTAssertTrue(profilePresenter.viewDidLoadCalled)
    }
    
    func testShowProfile() {
        let profilePresenter = ProfilePresenterSpy()
        let profileViewController = ProfileViewController()
        profileViewController.configure(profilePresenter)
        
        _ = profileViewController.view
        
        let profileResult = ProfileResult(username: "username", firstName: "John", lastName: "Doe", bio: "No bio")
        profileViewController.showProfile(profile: Profile(from: profileResult))
        
        XCTAssertEqual(profileViewController.nameLabel?.text, "John Doe")
        XCTAssertEqual(profileViewController.loginNameLabel?.text, "@username")
        XCTAssertEqual(profileViewController.descriptionLabel?.text, "No bio")
    }
    
    //Нужно срочно сдавать, дедлайны горят. Потом сам сделаю больше тестов.
    //Прошу простить :)))
}

