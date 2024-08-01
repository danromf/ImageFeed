//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Даниил Романов on 01.08.2024.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    var loadAuthViewCalled = false
    
    func load(request: URLRequest) {
        loadAuthViewCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
    
}
