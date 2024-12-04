import UIKit

final class MovieQuizViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Private Properties
    private var correctAnswers = 0
    private var currentQuestion: QuizQuestion?
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private lazy var statisticService: StatisticServiceProtocol = {
        let statisticService = StatisticService()
        return statisticService
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFonts()
        
        presenter.viewController = self
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        activityIndicator.startAnimating()
        questionFactory.loadData()
    }
    
    //MARK: - IB Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        blockButtons()
        
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        blockButtons()
        
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
    }
    
    //MARK: - Private Methods
    private func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    private func unblockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func setFonts() {
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8.0
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func createFinalAlertModel() -> AlertModel {
        let message = """
            Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
            
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: message,
            buttonText: "Сыграть еще раз") { [weak self] in
                guard let self = self else { return }
                    
                presenter.resetQuestionIndex()
                self.correctAnswers = 0
                    
                questionFactory?.requestNextQuestion()
            }
        return alertModel
    }
    
    private func showNextQuestionOrResults() {
        unblockButtons()
        
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0.0
        
        if presenter.isLastQuestion() {
            statisticService.store(gameResult: GameResult(correct: correctAnswers, total: presenter.questionsAmount, date: Date()))
            
            alertPresenter = AlertPresenter(viewController: self)
            let finalAlertModel = createFinalAlertModel()
            
            DispatchQueue.main.async { [weak self] in
                self?.alertPresenter?.show(alertModel: finalAlertModel)
            }
        } else {
            presenter.switchToNextQuestion()
            activityIndicator.startAnimating()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.stopAnimating()
        
        alertPresenter = AlertPresenter(viewController: self)
        let networkErrorAlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова") { [weak self] in
                guard let self = self else { return }
                    
                presenter.resetQuestionIndex()
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter?.show(alertModel: networkErrorAlertModel)
    }
}

//MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
            
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailRequestNextQuestion(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
