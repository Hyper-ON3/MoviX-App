//
//  SearchContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class SearchContainer: ContainerProtocol {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(SearchViewModelProtocol.self) { _ in
            return SearchViewModel()
        }
        
        container.storyboardInitCompleted(SearchViewController.self) { r, vc in
            vc.searchViewModel = r.resolve(SearchViewModelProtocol.self)
        }
    }
    
    
    
}
