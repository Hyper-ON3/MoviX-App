//
//  FilmsByGenreCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import UIKit

class FilmsByGenreCoordinator: Coordinator {
    
    weak var parentCoordinator: HomeCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var info: GenreList?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let vc = FilmsByGenreViewController.createObject(from: .filmsByGenre)
        vc.coordinator = self
        vc.filmsViewModel?.genreInfo = info
        navigationController.pushViewControllerWithFlipAnimation(viewController: vc)
    }
    
    func didFinishFilms() {
        parentCoordinator?.childDidFinish(self)
    }
}
