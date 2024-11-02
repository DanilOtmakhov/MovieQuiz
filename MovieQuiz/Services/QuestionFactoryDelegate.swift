//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}