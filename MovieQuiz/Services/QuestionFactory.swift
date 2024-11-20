//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import Foundation

final class QuestionFactory {
    
    private let moviesLoader: MoviesLoaderProtocol
    private var movies: [MostPopularMovie] = []
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegate? = nil) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
}

extension QuestionFactory: QuestionFactoryProtocol {
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            }
            catch let error {
                self.delegate?.didFailRequestNextQuestion(with: error)
            }
            
            let rating = Float(movie.rating) ?? 0
            var randomRating: Int
            repeat {
                randomRating = Int.random(in: 7...9)
            } while Float(randomRating) == rating
            let moreLess = Bool.random() ? "больше" : "меньше"
            let text = "Рейтинг этого фильма \(moreLess) чем \(randomRating)?"
            let correctAnswer = moreLess == "больше" ? rating > Float(randomRating) : rating < Float(randomRating)
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer
            )
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
