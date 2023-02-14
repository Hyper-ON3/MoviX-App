//
//  UserDetailsModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 12/01/2023.
//

import Foundation

struct GetAccountDetailsModel: Codable {
    
    let id: Int
    let name: String?
    let includeAdult: Bool?
    let username: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case includeAdult = "include_adult"
        case username
    }
}
