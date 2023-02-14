//
//  CustomToolBar.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

protocol CustomToolBarDelegate {
    
    func toolBarButtonsPressed(tag: Int)
}

class CustomToolBar: BaseUIViewComponent {

    @IBOutlet weak var toolBarView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var delegate: CustomToolBarDelegate?
    
    func configureElements() {
        
        toolBarView.layer.cornerRadius = 20
        backgroundImageView.layer.cornerRadius = 20
    }
    
    @IBAction func toolBarButtonsTapped(_ sender: UIButton) {
        
        delegate?.toolBarButtonsPressed(tag: sender.tag)
    }
}
