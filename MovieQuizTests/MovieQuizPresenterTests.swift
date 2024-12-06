//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Danil Otmakhov on 06.12.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func blockButtons() {}
    
    func unblockButtons() {}
    
    func highlightImageBorder(isCorrect: Bool) {}
    
    func hideImageBorder() {}
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {}
    
    func show(alertModel: MovieQuiz.AlertModel) {}
    
    func showNetworkError(message: String) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let presenter = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = presenter.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
