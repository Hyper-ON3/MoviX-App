//
//  DetailsModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import Foundation

struct DetailsModel {
    
    var id: Int
    var backdropPath: String
    var filmName: String
    var genres: [Genres]
    var filmInfo: [String]
    var filmRating: String
    var about: String
    var status: String
}
