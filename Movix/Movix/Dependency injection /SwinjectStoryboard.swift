//
//  SwinjectStoryboard+Extension.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/02/2023.
//

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    public static func setup() {

        let main = MainContainer(container: defaultContainer)
        main.setupContainer()
    }
    

}
