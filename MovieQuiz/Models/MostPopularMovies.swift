//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 16.11.2024.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}
