//
//  ItemListStatusModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation

struct ItemListStatusModel: Codable {
    
    var itemPresent: Bool?
    var success: Bool?
    
    enum CodingKeys: String, CodingKey {
        case itemPresent = "item_present"
    }
}
