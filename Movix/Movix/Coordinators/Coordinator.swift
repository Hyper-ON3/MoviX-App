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
}


