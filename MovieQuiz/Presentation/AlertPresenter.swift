//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "Alert: " + alertModel.title
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion()
            }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
