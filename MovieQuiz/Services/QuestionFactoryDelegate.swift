//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
    func didFailRequestNextQuestion(with error: Error)
}
