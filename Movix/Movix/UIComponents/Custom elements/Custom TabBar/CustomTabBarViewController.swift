//
//  CustomTabBarViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/02/2023.
//

import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    private var shapeLayer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        setTabBar2()
    }
    
    private func configureTabBar() {
        
        self.delegate = self
        self.selectedIndex = 1
        
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
    }
    
    //MARK: - The second option of a custom TabBar
    
    //  TabBar in the form of a capsule
    private func setTabBar1() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnY, y: tabBar.bounds.minY - positionOnY, width: width, height: height),
                                      cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.white.cgColor
    }
    
    //MARK: - The second option of a custom TabBar
    
    //  TabBar with a complex shape
    private func setTabBar2() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor(red: 235/255, green: 235/255, blue: 235/255 , alpha: 1).cgColor
        shapeLayer.lineWidth = 1.0
        
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.red.cgColor
        shapeLayer.shadowOpacity = 0.3
        
        if let oldShapeLayer = self.shapeLayer {
            tabBar.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        }else{
            tabBar.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {

        let height: CGFloat = 45.0
        let path = UIBezierPath()
        let centerWidth = tabBar.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0)) // start top left
        path.addLine(to: CGPoint(x: (centerWidth - height * 2), y: 0)) // the beginning of the trough
        // first curve down
        path.addCurve(to: CGPoint(x: centerWidth, y: height),
                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0), controlPoint2: CGPoint(x: centerWidth - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (centerWidth + height * 2), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 35, y: height), controlPoint2: CGPoint(x: (centerWidth + 30), y: 0))

        // complete the rect
        path.addLine(to: CGPoint(x: tabBar.frame.width, y: 0))
        path.addLine(to: CGPoint(x: tabBar.frame.width, y: tabBar.frame.height + 50))
        path.addLine(to: CGPoint(x: 0, y: tabBar.frame.height + 50))
        path.close()

        return path.cgPath
    }
}
