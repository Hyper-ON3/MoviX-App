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
        navigationController.setViewControllerWithAnimation(viewController: vc)
    }
    
    func goTo(screen: Screen) {
        
        switch screen {
        case .login:
            childCoordinators.removeAll()
            showLoginFlow()
        case .home:
            childCoordinators.removeAll()
            showMainFlow()
        }
    }
    
    private func showLoginFlow() {
        
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.parentCoordinator = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    private func showMainFlow() {
        
        let tabCoordinator = TabBarCoordinator.init(navigationController: navigationController)
        tabCoordinator.parentCoordinator = self
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
    
}
