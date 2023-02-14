//
//  FavoriteMovieDetailsCacheModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation
import RealmSwift

class FavoriteMovieDetailsCacheModel: Object {
    
    @Persisted (primaryKey: true) var id: Int
    @Persisted var backdropPath: String = ""
    @Persisted var filmName: String = ""
    @Persisted var genres: List<MovieGenres>
    @Persisted var filmInfo: List<String>
    @Persisted var filmRating: String = ""
    @Persisted var about: String = ""
    @Persisted var status: String = ""
    
    convenience init(id: Int, backdropPath: String, filmName: String, genres: List<MovieGenres>, filmInfo: List<String>, filmRating: String, about: String, status: String) {
        self.init()
        self.id = id
        self.backdropPath = backdropPath
        self.filmName = filmName
        self.genres = genres
        self.filmInfo = filmInfo
        self.filmRating = filmRating
        self.about = about
        self.status = status
    }
}

class MovieGenres: Object {
    
    @Persisted var id: Int = 0
    @Persisted var name: String = ""
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
}

