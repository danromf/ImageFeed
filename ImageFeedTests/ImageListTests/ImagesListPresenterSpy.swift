import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var fetchPhotosCalled: Bool = false
    var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fullImageURL(for indexPath: IndexPath) -> String {
        return ""
    }
    
    func countPhotos() -> Int {
        return 0
    }
    
    func changeLike(for indexPath: IndexPath, completion: @escaping (Result<Void, any Error>) -> Void) {
    }
    
    func photo(for indexPath: IndexPath) -> ImageFeed.Photo? {
        return nil
    }
    
    func format(date: Date?) -> String {
        return ""
    }
    
    func fetchPhotosNextPage() {
        fetchPhotosCalled = true
    }
}
