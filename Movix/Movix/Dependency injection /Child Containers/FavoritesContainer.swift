//
//  FavoritesContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class FavoritesContainer: ContainerProtocol {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(FavoritesViewModelProtocol.self) { r in
            return FavoritesViewModel(repository: r.resolve(RepositoryProtocol.self))
        }
        
        container.storyboardInitCompleted(FavoritesViewController.self) { r, vc in
            vc.favoritesViewModel = r.resolve(FavoritesViewModelProtocol.self)
        }
    }
}
