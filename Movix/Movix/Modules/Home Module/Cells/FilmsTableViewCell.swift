//
//  FilmsTableViewCell.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 13/01/2023.
//

import UIKit
import RxSwift
import RxCocoa

class FilmsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filmsCollectionView: UICollectionView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
