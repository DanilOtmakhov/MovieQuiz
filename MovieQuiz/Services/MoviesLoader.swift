//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 16.11.2024.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader {
    
    private let networkClient: NetworkRouting
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        
        return url
    }
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
}

extension MoviesLoader: MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, any Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch(result) {
            case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
