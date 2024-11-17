import UIKit

final class MovieQuizViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let questionsAmount: Int = 10
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
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
        
        let questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory = questionFactory
        
        showLoadingIndicator()
        questionFactory.loadData()
    }
    
    //MARK: - Methods
    private func blockButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }

    private func unblockButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    // Настройка шрифтов сделана через код, так как в Storyboard в настройках лейблов шрифт не отображается. Пробовал на 16 и 15.4 версиях Xcode.
    private func setFonts() {
        textLabel.font = UIFont(name: "YSDisplay-Bold", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
        yesButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        noButton.titleLabel?.font = UIFont(name: "YSDisplay-Medium", size: 20)
        questionLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
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
    
    private func isLastQuestion() -> Bool {
        return currentQuestionIndex == questionsAmount - 1
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
                    
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                    
                questionFactory?.requestNextQuestion()
            }
        return alertModel
    }
    
    private func showNextQuestionOrResults() {
        unblockButtons()
        
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0.0
        
        if isLastQuestion() {
            statisticService.store(gameResult: GameResult(correct: correctAnswers, total: questionsAmount, date: Date()))
            
            alertPresenter = AlertPresenter(viewController: self)
            let finalAlertModel = createFinalAlertModel()
            
            DispatchQueue.main.async { [weak self] in
                self?.alertPresenter?.show(alertModel: finalAlertModel)
            }
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        alertPresenter = AlertPresenter(viewController: self)
        let networkErrorAlertModel = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать снова") { [weak self] in
                guard let self = self else { return }
                    
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter?.show(alertModel: networkErrorAlertModel)
    }
    
    //MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        blockButtons()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        blockButtons()
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }    
}


//MARK: - QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
            
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func didFailRequestNextQuestion(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
}
