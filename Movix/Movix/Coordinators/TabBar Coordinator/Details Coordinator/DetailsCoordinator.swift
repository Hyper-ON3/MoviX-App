//
//  DetailsCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import UIKit

class DetailsCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    var id: Int?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        let vc = DetailsViewController.createObject(from: .details)
        vc.coordinator = self
        vc.detailsViewModel?.filmId = id
        navigationController.pushViewControllerWithFlipAnimation(viewController: vc)
    }
    
    func didFinishDetails() {
        parentCoordinator?.childDidFinish(self)
    }
    
}
