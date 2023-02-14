//
//  SearchCollectionViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 24/01/2023.
//

import UIKit
import SDWebImage

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    
    func configureCell(with model: SearchModelResult) {
        
        if model.posterPath == "" {
            posterImageView.image = UIImage(named: K.ImagesName.noImage)
        } else {
            posterImageView.sd_setImage(with: URL(string: K.API.getPosterImage + model.posterPath))
        }
        
        filmNameLabel.text = model.filmsName
        
        posterImageView.layer.cornerRadius = 15
        posterImageView.layer.borderWidth = 1
    }
}
