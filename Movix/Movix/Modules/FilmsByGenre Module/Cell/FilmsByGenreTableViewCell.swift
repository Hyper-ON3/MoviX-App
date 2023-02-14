//
//  FilmsByGenreTableViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class FilmsByGenreTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView! 
    @IBOutlet weak var filmNameLabel: UILabel!
    
    func configureCell(with model: FilmsListModel) {
        
        posterImageView.sd_setImage(with: URL(string: K.API.getPosterImage + "\(model.posterPath)"))
        
        filmNameLabel.text = model.title
        
        posterImageView.layer.cornerRadius = 25
        posterImageView.layer.borderWidth = 1
    }
    
}
