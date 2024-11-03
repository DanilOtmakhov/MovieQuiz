//
//  ResultAlertPresenter.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func show(alertModel: AlertModel)
}

final class ResultAlertPresenter {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension ResultAlertPresenter: AlertPresenterProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: alertModel.buttonText,
            style: .default) { _ in
                alertModel.completion()
            }
        
        alert.addAction(action)
        
        viewController?.present(alert, animated: true)
    }
}
