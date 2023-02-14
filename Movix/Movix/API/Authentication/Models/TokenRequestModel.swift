//
//  TokenRequestModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 11/01/2023.
//

import Foundation

struct TokenRequestModel: Codable {
 
    let requestToken: String
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token"
    }
}
