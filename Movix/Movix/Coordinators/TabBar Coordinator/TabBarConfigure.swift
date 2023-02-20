//
//  TabBarConfigure.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/02/2023.
//

import UIKit

enum TabBarPage {
    
    case home
    case search
    case favorites
    
    init?(index: Int) {
        
        switch index {
        case 0:
            self = .search
        case 1:
            self = .home
        case 2:
            self = .favorites
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        
        switch self {
        case .search:
            return "Search"
        case .home:
            return ""
        case .favorites:
            return "Favorites"
        }
    }
    
    func pageOrderNumber() -> Int {
        
        switch self {
        case .search:
            return 0
        case .home:
            return 1
        case .favorites:
            return 2
        }
    }
    
    func setPageImage() -> UIImage? {
        
        switch self {
        case .search:
            return UIImage(named: K.ImagesName.search)
        case .home:
            return UIImage(named: K.ImagesName.homeBig)
        case .favorites:
            return UIImage(named: K.ImagesName.favorites)
        }
    }
    
    func setSelectedImage() -> UIImage? {
        
        switch self {
        case .search:
            return UIImage(named: K.ImagesName.searchSelected)
        case .home:
            return UIImage(named: K.ImagesName.homeBigSelected)
        case .favorites:
            return UIImage(named: K.ImagesName.favoritesSelected)
        }
    }
}
