//
//  FavoritesTableViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 02/02/2023.
//

import UIKit
import SDWebImage

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    
    
    func configureCell(with model: FavoritesMoviesCacheModel) {
        
        posterImageView.layer.cornerRadius = 30
        
        posterImageView.sd_setImage(with: URL(string: K.API.getPosterImage + model.backdropPath))
        filmNameLabel.text = model.filmName
        
    }
    
}
