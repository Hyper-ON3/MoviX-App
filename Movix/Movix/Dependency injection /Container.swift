//
//  Container.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject

protocol ContainerProtocol {
    
    var container: Container { get set }
    
    func setupContainer()
}
