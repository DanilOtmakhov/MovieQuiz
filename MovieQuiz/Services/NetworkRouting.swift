//
//  NetworkRouting.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 03.12.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
