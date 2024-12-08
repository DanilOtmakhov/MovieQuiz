//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 06.12.2024.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func blockButtons()
    func unblockButtons()
    
    func highlightImageBorder(isCorrect: Bool)
    func hideImageBorder()
    
    func show(quiz step: QuizStepViewModel)
    func show(alertModel: AlertModel)
}
