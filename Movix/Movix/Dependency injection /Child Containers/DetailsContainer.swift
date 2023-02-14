//
//  DetailsContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class DetailsContainer: ContainerProtocol {
    
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(DetailsViewModelProtocol.self) { r in
            return DetailsViewModel(repository: r.resolve(RepositoryProtocol.self))
        }
        
        container.storyboardInitCompleted(DetailsViewController.self) { r, vc in
            vc.detailsViewModel = r.resolve(DetailsViewModelProtocol.self)
        }
    }
    
    
    
}
