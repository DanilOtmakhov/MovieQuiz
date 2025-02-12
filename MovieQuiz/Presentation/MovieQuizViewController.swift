//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov.
//

import UIKit

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

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Views
    
    private lazy var questionLabel: UILabel = {
        $0.text = "Вопрос:"
        $0.font = UIFont(name: "YSDisplay-Medium", size: 20)
        $0.textColor = .ypWhite
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var counterLabel: UILabel = {
        $0.text = "1/10"
        $0.font = UIFont(name: "YSDisplay-Medium", size: 20)
        $0.textColor = .ypWhite
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var imageView: UIImageView = {
        $0.backgroundColor = .ypWhite
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private lazy var textLabel: UILabel = {
        $0.text = "Рейтинг этого фильма меньше чем 5?"
        $0.font = UIFont(name: "YSDisplay-Bold", size: 23)
        $0.textColor = .ypWhite
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    private lazy var yesButton: UIButton = {
        $0.setTitle("Да", for: .normal)
        $0.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        $0.setTitleColor(.ypBlack, for: .normal)
        $0.backgroundColor = .ypWhite
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(didTapYesButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var noButton: UIButton = {
        $0.setTitle("Нет", for: .normal)
        $0.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        $0.setTitleColor(.ypBlack, for: .normal)
        $0.backgroundColor = .ypWhite
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())
    
    // MARK: - Private Properties
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - Public Methods
    
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
    
    // MARK: - Actions
    
    @objc private func didTapYesButton() {
        blockButtons()
        presenter.didTapYesButton()
    }
    
    @objc private func didTapNoButton() {
        blockButtons()
        presenter.didTapNoButton()
    }
}

// MARK: - Setup

extension MovieQuizViewController {
    private func setupViewController() {
        view.backgroundColor = .ypBlack
        
        let titleStack = UIStackView(arrangedSubviews: [questionLabel, counterLabel])
        titleStack.axis = .horizontal
        titleStack.spacing = 20

        let buttonStack = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [titleStack, imageView, textLabel, buttonStack])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        [mainStack, loadingIndicator].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // Исправлено
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
