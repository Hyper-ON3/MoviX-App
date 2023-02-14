//
//  HomeContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class HomeContainer: ContainerProtocol {
    
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(HomeViewModelProtocol.self) { _ in
            return HomeViewModel()
        }
        
        container.storyboardInitCompleted(HomeViewController.self) { r, vc in
            vc.homeViewModel = r.resolve(HomeViewModelProtocol.self)
        }
    }
    
    
    
}
