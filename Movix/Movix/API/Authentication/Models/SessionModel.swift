//
//  SessionModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 11/01/2023.
//

import Foundation

struct SessionModel: Codable {
    
    let success: Bool
    let sessionID: String?

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
