//
//  Storyboarded.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

enum Storyboards: String {
    case logo = "Logo"
    case login = "Login"
    case genres = "Genres"
    case filmsByGenre = "FilmsByGenre"
    case details = "Details"
    case search = "Search"
    case favorites = "Favorites"
}

protocol Storyboarded {
    
    static func createObject(from name: Storyboards) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func createObject(from name: Storyboards) -> Self {
        
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: name.rawValue , bundle: nil)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
