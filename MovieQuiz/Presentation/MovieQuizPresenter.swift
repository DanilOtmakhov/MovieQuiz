//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 05.12.2024.
//

import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount = 10
    
    // MARK: - Initializer
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        viewController.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Public Methods
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    // MARK: - Private Methods
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.unblockButtons()
        viewController?.hideImageBorder()
        
        if isLastQuestion() {
            statisticService.store(gameResult: GameResult(correct: correctAnswers, total: questionsAmount, date: Date()))
            
            let finalAlertModel = createFinalAlertModel()
            viewController?.show(alertModel: finalAlertModel)
        } else {
            switchToNextQuestion()
            viewController?.showLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func processAnswer(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        processAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
    }
    
    private func createFinalAlertModel() -> AlertModel {
        let message = """
            Ваш результат: \(correctAnswers)/\(questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }
                restartGame()
            }
        return alertModel
    }
    
    private func createNetworkErrorAlertModel(message: String, completion: @escaping () -> Void) -> AlertModel {
        let alertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова",
            completion: completion
        )
        return alertModel
    }
}

// MARK: - QuestionFactoryDelegate
extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
            
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadingIndicator()
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        let alertModel = createNetworkErrorAlertModel(message: error.localizedDescription) { [weak self] in
            self?.questionFactory?.loadData()
            self?.restartGame()
        }
        viewController?.show(alertModel: alertModel)
    }
    
    func didFailRequestNextQuestion(with error: any Error) {
        let alertModel = createNetworkErrorAlertModel(message: error.localizedDescription) { [weak self] in
            self?.questionFactory?.requestNextQuestion()
        }
        viewController?.show(alertModel: alertModel)
    }
}
