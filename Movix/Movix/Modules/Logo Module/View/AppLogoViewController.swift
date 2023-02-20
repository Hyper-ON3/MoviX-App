//
//  ViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 10/01/2023.
//

import UIKit
import Lottie
import CLTypingLabel

class AppLogoViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var animation: LottieAnimationView!
    @IBOutlet weak var appNameLabel: CLTypingLabel!
    
    weak var coordinator: MainCoordinator?
    var logoViewModel: LogoViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.play() { [weak self] _ in
            guard let self else { return }
            
            self.logoViewModel?.checkNetworkStatus(self.coordinator)
        }
        
        let gradient = GradientText.getGradientLayer(bounds: appNameLabel.bounds)
        appNameLabel.textColor = GradientText.gradientColor(bounds: appNameLabel.bounds, gradientLayer: gradient)
        appNameLabel.text = K.Titles.appName
    }
    
}

