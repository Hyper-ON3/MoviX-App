//
//  GradientText.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 10/02/2023.
//

import UIKit

class GradientText {
    
    static func gradientColor(bounds: CGRect, gradientLayer :CAGradientLayer) -> UIColor? {
        
    //Creating UIImage to get gradient color.
          UIGraphicsBeginImageContext(gradientLayer.bounds.size)
          gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return UIColor(patternImage: image!)
    }
    
    static func getGradientLayer(bounds : CGRect) -> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.systemBlue.cgColor, UIColor.white.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradient
    }
}
