//
//  GenreCollectionViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var genreView: UIView!
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!    
    
    func confugureElements(with model: GenreList) {
        
        genreView.layer.cornerRadius = 0.5 * genreImageView.bounds.size.width
        
        genreImageView.image = model.genreImage
        
        genreLabel.text = model.genreName
        
        
    }
    
}
