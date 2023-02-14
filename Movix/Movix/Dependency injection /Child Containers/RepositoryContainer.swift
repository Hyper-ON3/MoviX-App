//
//  RepositoryContainer.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 14/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

class RepositoryContainer: ContainerProtocol {
    var container: Container
    
    init(container: Container) {
        self.container = container
    }
    
    func setupContainer() {
        
        container.register(DBManagerProtocol.self) { _ in
            return DBManager()
        }
        
        container.register(RepositoryProtocol.self) { r in
            return Repository(dbManager: r.resolve(DBManagerProtocol.self))
        }
    }
}
