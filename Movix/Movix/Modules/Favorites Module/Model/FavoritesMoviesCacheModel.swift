//
//  FavoritesMoviesCacheModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 08/02/2023.
//

import Foundation
import RealmSwift

class FavoritesMoviesCacheModel: Object {
    
    @Persisted (primaryKey: true) var id: Int
    @Persisted var backdropPath: String = ""
    @Persisted var listName: String = ""
    @Persisted var filmName: String = ""
    
    convenience init (id: Int, backdropPath: String, listName: String, filmName: String) {
        self.init()
        self.id = id
        self.backdropPath = backdropPath
        self.listName = listName
        self.filmName = filmName
    }
}
