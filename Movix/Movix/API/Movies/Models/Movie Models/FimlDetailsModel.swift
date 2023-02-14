//
//  FimlDetailsModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import Foundation

// MARK: - FilmDetailsModel
struct FilmDetailsModel: Codable {
    let adult: Bool
    let backdropPath: String?
    let budget: Int
    let genres: [Genres]
    let id: Int
    let originalTitle, overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCountries: [ProductionCountry?]?
    let releaseDate: String
    let revenue, runtime: Int
    let status, tagline, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, id
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Genre
struct Genres: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let name: String?
}
