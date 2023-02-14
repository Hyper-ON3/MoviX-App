//
//  GetTrailerModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 23/01/2023.
//

import Foundation

// MARK: - Welcome
struct GetTrailerModel: Codable {
    let id: Int
    let results: [TrailerResult]
}

// MARK: - Result
struct TrailerResult: Codable {

    let name, key: String
    let size: Int
    let type: String
    let official: Bool
    let id: String

}
