//
//  LoginContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class LoginContainer: ContainerProtocol {
    
    var container: Container
    
    init(conteiner: Container) {
        self.container = conteiner
    }
    
    func setupContainer() {
        
        container.register(LoginViewModelProtocol.self) { _ in
            return LoginViewModel()
        }
        
        container.storyboardInitCompleted(LoginViewController.self) { r, vc in
            vc.loginViewModel = r.resolve(LoginViewModelProtocol.self)
        }
    }
}

