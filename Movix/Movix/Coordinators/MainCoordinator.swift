//
//  MainCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

enum Screen {
    
    case login
    case home
    case search
    case favorites
}

class MainCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = AppLogoViewController.createObject(from: .logo)
        vc.coordinator = self
        navigationController.setViewControllers([vc], animated: false)
    }
    
    //MARK: - Screens without data transfer in them
    
    func goTo(screen: Screen) {
        
        switch screen {
        case .login:
            let child = LoginCoordinator(navigationController: navigationController)
            child.parentCoordinator = self 
            childCoordinators.append(child)
            child.start()
        case .home:
            let child = HomeCoordinator(navigationController: navigationController)
            child.parentCoordinator = self
            childCoordinators.append(child)
            child.start()
        case .search:
            let child = SearchCoordinator(navigationController: navigationController)
            child.parentCoordinator = self
            childCoordinators.append(child)
            child.start()
        case .favorites:
            let child = FavoritesCoordinator(navigationController: navigationController)
            child.parentCoordinator = self
            childCoordinators.append(child)
            child.start()
        }
    }

    //MARK: - Screens with data transfer in them
    
    func goToFilmsByGenre(with info: GenreList) {
        let child = FilmsByGenreCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        child.info = info
        childCoordinators.append(child)
        child.start()
    }
    
    func goToDetails(with id: Int) {
        let child = DetailsCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        child.id = id
        childCoordinators.append(child)
        child.start()
    }
    
    //MARK: - Dismiss the screen
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

}
