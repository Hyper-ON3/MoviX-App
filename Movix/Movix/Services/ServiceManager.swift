//
//  ServiceManager.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 12/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ServiceManager {
    static let shared = ServiceManager()
    
    var errorMessage = ""
    var sessionId = ""
    var userDetails = BehaviorRelay<GetAccountDetailsModel>(value: GetAccountDetailsModel(id: 0,
                                                                                          name: "",
                                                                                          includeAdult: nil,
                                                                                          username: ""))

    func setRating(_ value: Double) -> String {
        
        var rating: String = ""
        let valueString = String(format: "%.1f", value)
        
        switch value {
        case 1.0...1.9: rating = "Rating: \(valueString) ⭐️"
        case 2.0...3.9: rating = "Rating: \(valueString) ⭐️⭐️"
        case 4.0...5.9: rating = "Rating: \(valueString) ⭐️⭐️⭐️"
        case 6.0...8.9: rating = "Rating: \(valueString) ⭐️⭐️⭐️⭐️"
        case 9.0...10.0: rating = "Rating: \(valueString) ⭐️⭐️⭐️⭐️⭐️"
        default: return "Rating: \(valueString)"
        }
        
        return rating
    }

    private init() {}
}
