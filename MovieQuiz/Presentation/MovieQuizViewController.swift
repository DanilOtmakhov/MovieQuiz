//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov.
//

import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    //MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: - Private Properties
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    //MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        blockButtons()
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        blockButtons()
        presenter.noButtonClicked()
    }
    
    //MARK: - Public Methods
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    func unblockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func hideImageBorder() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0.0
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(alertModel: AlertModel) {
        alertPresenter = AlertPresenter(viewController: self)
        alertPresenter?.show(alertModel: alertModel)
    }
    
    //MARK: - Private Methods
    private func setFonts() {
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
}
