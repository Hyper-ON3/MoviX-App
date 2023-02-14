//
//  MainContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject

class MainContainer: ContainerProtocol {
    
    var container: Container

    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        let logo = LogoContainer(container: container)
        logo.setupContainer()
        
        let login = LoginContainer(conteiner: container)
        login.setupContainer()
        
        let home = HomeContainer(container: container)
        home.setupContainer()
        
        let filmsByGenre = FilmsByGenreContainer(container: container)
        filmsByGenre.setupContainer()
        
        let details = DetailsContainer(container: container)
        details.setupContainer()
        
        let search = SearchContainer(container: container)
        search.setupContainer()
        
        let favorites = FavoritesContainer(container: container)
        favorites.setupContainer()
        
        let repository = RepositoryContainer(container: container)
        repository.setupContainer()
    }
}
