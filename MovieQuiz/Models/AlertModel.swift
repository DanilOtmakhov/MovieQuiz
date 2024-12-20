//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Danil Otmakhov on 25.10.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
