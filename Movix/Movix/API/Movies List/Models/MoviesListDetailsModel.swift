//
//  MoviesListDetailsModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation

// MARK: - Welcome
struct MoviesListDetailsModel: Codable {
    let createdBy, description: String
    let favoriteCount: Int
    let id: String
    let items: [FavoritesMoviesDetails]
    let itemCount: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case description
        case favoriteCount = "favorite_count"
        case id, items
        case itemCount = "item_count"
        case name
    }
}

// MARK: - Item
struct FavoritesMoviesDetails: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let mediaType, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case mediaType = "media_type"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
