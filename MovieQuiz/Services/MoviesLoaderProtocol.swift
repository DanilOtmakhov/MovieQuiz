//
//  MoviesLoaderProtocol.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 16.11.2024.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}
