//
//  SearchCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 24/01/2023.
//

import UIKit

class SearchCoordinator: Coordinator {
    
    var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
        
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SearchViewController.createObject(from: .search)
        vc.coordinator = self
        navigationController.setViewControllerWithAnimation(viewController: vc)
    }
    
    func didFinishSearch() {
        parentCoordinator?.childDidFinish(self)
    }
    
}

