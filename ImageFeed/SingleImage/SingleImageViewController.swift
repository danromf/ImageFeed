import UIKit

final class SingleImageViewController: UIViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    var fullImageURL: String? {
        didSet {
            guard isViewLoaded else { return }
            
            setupImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 0.001
        scrollView.maximumZoomScale = 1.25
        
        setupImage()
    }
    
    private func setupImage() {
        guard isViewLoaded, let fullImageURL = fullImageURL else { return }
        
        UIBlockingProgressHUD.show()
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: fullImageURL)
            ) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let imageResult):
                imageView.frame.size = imageResult.image.size
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать еще раз?",
            preferredStyle: .alert)
        
        
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                    self?.setupImage()
        }
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)
        
        alertController.addAction(retryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
            
        view.layoutIfNeeded()
            
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
            
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
            
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
            
        scrollView.setZoomScale(scale, animated: false)
        scrollView.minimumZoomScale = scale
            
        scrollView.layoutIfNeeded()
            
        centerImage()
    }
        
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
                    
        let horizontalOffset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalOffset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
                    
        scrollView.contentInset = UIEdgeInsets(top: verticalOffset, left: horizontalOffset,
                                                   bottom:verticalOffset,  right: horizontalOffset)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        
        let itemsToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                
        activityViewController.excludedActivityTypes = [.addToReadingList, .postToFlickr]
                
        present(activityViewController, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerImage()
    }
}
