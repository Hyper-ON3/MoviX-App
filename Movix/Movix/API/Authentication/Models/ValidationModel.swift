//
//  ValidationModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 11/01/2023.
//

import Foundation

struct ValidationModel: Codable {
    
    let success: Bool?
    let statusMessage: String?
    let requestToken: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusMessage = "status_message"
        case requestToken = "request_token"
    }
}
