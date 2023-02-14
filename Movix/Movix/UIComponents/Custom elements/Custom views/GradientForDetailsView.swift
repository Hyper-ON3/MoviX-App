//
//  GradientForDetailsView.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import UIKit

class GradientForDetailsView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red: 3/255, green: 7/255, blue: 30/255, alpha: 1).cgColor]
        gradientLayer.locations = [0.0, 0.37]
    }
}
