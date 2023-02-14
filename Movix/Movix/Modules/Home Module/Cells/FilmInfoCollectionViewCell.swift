//
//  FilmInfoCollectionViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit
import SDWebImage

class FilmInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    
    func configureCell(with model: FilmsCategoryModel) {
        
        filmImageView.layer.cornerRadius = 12
        filmImageView.layer.borderWidth = 1
        
        filmImageView.sd_setImage(with: URL(string: K.API.getPosterImage + "\(model.posterPath)"))
        filmNameLabel.text = model.title
 
    }
}
