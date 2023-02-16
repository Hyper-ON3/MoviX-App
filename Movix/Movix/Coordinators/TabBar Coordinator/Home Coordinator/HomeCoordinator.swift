//
//  GenresCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

class HomeCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController.createObject(from: .genres)
        vc.coordinator = self
        navigationController.setViewControllerWithAnimation(viewController: vc)
    }
    
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

    func didFinishHome() {
        parentCoordinator?.childDidFinish(self)
    }    
}
