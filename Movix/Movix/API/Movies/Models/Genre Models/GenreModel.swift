//
//  GenreModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import Foundation

struct GenreModel: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
