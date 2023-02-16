//
//  Coordinator.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 12/01/2023.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func childDidFinish(_ child: Coordinator?)
}

enum CoordinatorType {
    case app, login, main
}

extension Coordinator {

    func childDidFinish(_ child: Coordinator?) {
        
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
