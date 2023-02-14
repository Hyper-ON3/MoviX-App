//
//  FavoritesCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 02/02/2023.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    
    var childCoordinators = [Coordinator]()
    var parentCoordinator: MainCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FavoritesViewController.createObject(from: .favorites)
        vc.coordinator = self
        navigationController.setViewControllerWithAnimation(viewController: vc)
    }
    
    func didFinishFavorites() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
