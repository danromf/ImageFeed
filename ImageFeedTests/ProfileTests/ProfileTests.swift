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
}

