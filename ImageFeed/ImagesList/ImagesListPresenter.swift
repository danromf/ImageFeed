import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fullImageURL(for indexPath: IndexPath) -> String
    func countPhotos() -> Int
    func changeLike (for indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void)
    func photo(for indexPath: IndexPath) -> Photo?
    func format(date: Date?) -> String
    func fetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    private let imagesListService = ImagesListService.shared
    
    private var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self else { return }
                    
                    self.updateTableView()
                }
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            self.view?.updateTableViewAnimated(with: oldCount..<newCount)
        }
    }
    
    func photo(for indexPath: IndexPath) -> Photo? {
        guard indexPath.row < imagesListService.photos.count else { return nil }
        
        return photos[indexPath.row]
    }
    
    func countPhotos() -> Int {
        return photos.count
    }
    
    func fullImageURL(for indexPath: IndexPath) -> String {
        return photos[indexPath.row].largeImageURL
    }
    
    func changeLike (for indexPath: IndexPath, completion: @escaping (Result<Void, Error>) -> Void) {
        let photo = photos[indexPath.row]
        
        view?.showActivityIndicator()
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] (result: Result<Void, Error>) in
            guard let self else { return }
            
            view?.dismissActivityIndicator()
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                completion(.success(()))
            case .failure(let error):
                print("[ImagesListPresenter] Error: \(error.localizedDescription)")
            }
        }
    }
    
    func format(date: Date?) -> String {
        guard let date = date else { return "" }
        let formatDate = dateFormatter.string(from: date)
        
        return formatDate
    }
}
