//
//  FilmsByGenre.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import Foundation

struct FilmsByGenreModel: Codable {
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Result: Codable {
   
    let id: Int
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let voteAverage: Double


    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
   
    }
}
