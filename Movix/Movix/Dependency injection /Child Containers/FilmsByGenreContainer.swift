//
//  FilmsByGenreContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class FilmsByGenreContainer: ContainerProtocol {
    
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(FilmsByGenreProtocol.self) { _ in
            return FilmsByGenreViewModel()
        }
        
        container.storyboardInitCompleted(FilmsByGenreViewController.self) { r, vc in
            vc.filmsViewModel = r.resolve(FilmsByGenreProtocol.self)
        }
    }
    
    
    
}
