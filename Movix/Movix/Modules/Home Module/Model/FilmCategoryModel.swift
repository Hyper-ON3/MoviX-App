//
//  FilmsCategoryModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 17/01/2023.
//

import Foundation
import RxDataSources

struct FilmsCategory {

    var header: String
    var items: [FilmsCategoryItem]
}

extension FilmsCategory: SectionModelType {

    init(original: FilmsCategory, items: [FilmsCategoryItem]) {
        self = original
        self.items = items.map { $0 }
    }
}

struct FilmsCategoryItem {

    var items: [FilmsCategoryModel]
}

struct FilmsCategoryModel {
    
    let id: Int
    let posterPath, releaseDate, title: String
    let voteAverage: String

}
