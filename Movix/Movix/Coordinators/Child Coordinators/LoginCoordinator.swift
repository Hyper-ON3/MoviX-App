//
//  LoginCoordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

class LoginCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?
    var childCoordinators = [Coordinator]() 
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LoginViewController.createObject(from: .login)
        vc.coordinator = self
        navigationController.setViewControllerWithAnimation(viewController: vc)
    }
    
    func didFinishLogin() {
        parentCoordinator?.childDidFinish(self)
    }
}

