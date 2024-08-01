//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Даниил Романов on 01.08.2024.
//

import UIKit

struct AlertModel {
    let title: String
    let text: String
    let buttonText: String
    var completion: ((UIAlertAction) -> Void)? = nil
}

final class AlertPresenter {
    weak var delegate: UIViewController?
    
    static func showAlert(alert model: AlertModel, on screen: UIViewController) -> UIAlertController?  {
        let alert = UIAlertController(
            title: model.title,
            message: model.text,
            preferredStyle: .alert)
        let alertAction = UIAlertAction(title: model.buttonText, style: .default, handler: model.completion)
        
        alert.addAction(alertAction)
        screen.present(alert, animated: true, completion: nil)
        return alert
    }
}
