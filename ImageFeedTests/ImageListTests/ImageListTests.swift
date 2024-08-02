@testable import ImageFeed
import XCTest

final class ImageListTests: XCTestCase {
    func testImagesListViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListPresenter = ImagesListPresenterSpy()
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        imagesListViewController.configure(imagesListPresenter)
        
        _ = imagesListViewController.view
        
        XCTAssertTrue(imagesListPresenter.viewDidLoadCalled)
    }
    
    func testViewDidLoadConfiguresTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        _ = imagesListViewController.view
        XCTAssertNotNil(imagesListViewController.tableView.delegate)
        XCTAssertNotNil(imagesListViewController.tableView.dataSource)
    }
}
