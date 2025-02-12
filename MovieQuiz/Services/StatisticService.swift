//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 02.11.2024.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(gameResult: GameResult)
}

final class StatisticService {
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
    }
    
    private let storage: UserDefaults = .standard
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
}

extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            if let data = UserDefaults.standard.data(forKey: Keys.bestGame.rawValue) {
                let decoder = JSONDecoder()
                if let gameResult = try? decoder.decode(GameResult.self, from: data) {
                    return gameResult
                }
            }
            return GameResult(correct: 0, total: 0, date: Date())
        }
        set {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(newValue) {
                UserDefaults.standard.set(data, forKey: Keys.bestGame.rawValue)
            }
        }
    }
    
    var totalAccuracy: Double {
        guard gamesCount != 0 else { return 0 }
        let accuracy = Double(correctAnswers) / Double(10 * gamesCount) * 100
        return accuracy
    }
    
    func store(gameResult: GameResult) {
        correctAnswers += gameResult.correct
        gamesCount += 1
        if gameResult >= bestGame {
            bestGame = gameResult
        }
    }
}
