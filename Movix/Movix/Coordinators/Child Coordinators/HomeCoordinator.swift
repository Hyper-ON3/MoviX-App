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
    
    func didFinishHome() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
