import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(with rangeOfCells: Range <Int>)
    func showActivityIndicator()
    func dismissActivityIndicator()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    @IBOutlet var tableView: UITableView!
    
    private var presenter: ImagesListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func showActivityIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func dismissActivityIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateTableViewAnimated(with rangeOfCells: Range <Int>) {
        tableView.performBatchUpdates {
            let indexPaths = rangeOfCells.map { i in
                IndexPath(row: i, section: 0)
                }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.fullImageURL = presenter?.fullImageURL(for: indexPath)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.countPhotos() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photo = presenter?.photo(for: indexPath) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: URL(string: photo.largeImageURL),
            placeholder: UIImage(named: "photo_placeholder")
        ) { [weak self] _ in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.dateLabel.text = presenter?.format(date: photo.createdAt)
        
        cell.setIsLiked(isLiked: photo.isLiked)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photo(for: indexPath) else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.right - imageInsets.left
        
        let scale = imageViewWidth / photo.size.width
        
        let cellHeight = scale * photo.size.height + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let countPhotos = presenter?.countPhotos() else { return }
        if indexPath.row == countPhotos - 1 {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard 
            let indexPath = tableView.indexPath(for: cell),
            let photo = presenter?.photo(for: indexPath)
        else { return }
        
        presenter?.changeLike(for: indexPath) { [weak cell] (result: Result<Void, Error>) in
            guard let cell else { return }
            switch result {
            case .success:
                cell.setIsLiked(isLiked: !photo.isLiked)
            case .failure(let error):
                print("[ImagesListViewController] Error: \(error.localizedDescription)")
            }
        }
    }
}
