//
//  Gradient.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 10/01/2023.
//

import UIKit

class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
    }
}
