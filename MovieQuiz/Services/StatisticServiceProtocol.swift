//
//  StatisticServiceProtocol.swift
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
