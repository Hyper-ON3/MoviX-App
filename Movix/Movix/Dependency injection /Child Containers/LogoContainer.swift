//
//  LogoContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class LogoContainer: ContainerProtocol {
    
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(LogoViewModelProtocol.self) { _ in
            return LogoViewModel()
        }
        
        container.storyboardInitCompleted(AppLogoViewController.self) { r, vc in
            vc.logoViewModel = r.resolve(LogoViewModelProtocol.self)
        }
    }
}
