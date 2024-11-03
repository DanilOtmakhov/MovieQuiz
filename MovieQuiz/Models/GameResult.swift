//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 02.11.2024.
//

import Foundation

struct GameResult: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.correct < rhs.correct
    }
    
    static func >=(lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.correct >= rhs.correct
    }
}
