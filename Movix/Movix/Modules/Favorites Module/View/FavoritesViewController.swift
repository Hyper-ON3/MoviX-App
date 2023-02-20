//
//  FavoritesViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 02/02/2023.
//

import UIKit
import RxSwift
import Lottie

class FavoritesViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emptyAnimationView: LottieAnimationView!
    
    var coordinator: FavoritesCoordinator?
    var favoritesViewModel: FavoritesViewModelProtocol?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favoritesViewModel?.loadFavoriteMovies()
        favoritesViewModel?.getMovieListData()
        
    }
    //MARK: - UI Configuration functions
    
    private func configureUI() {
        
        warningLabel.isHidden = true
        
        favoritesViewModel?.loadFavoriteMovies()
        favoritesViewModel?.getMovieListData()
        
        favoritesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        favoritesTableView.delegate = self
        
        bindTableView()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.endRefreshing()
    }
    
    //MARK: - Animation functions
    
    private func isFavoritesEmpty(animate: Bool) {
        
        emptyAnimationView.loopMode = .autoReverse
        
        if animate == true {
            title = K.Titles.favoritesMovie
            self.emptyAnimationView.isHidden = false
            self.warningLabel.isHidden = false
            emptyAnimationView.play()
        } else {
            emptyAnimationView.stop()
            self.warningLabel.isHidden = true
            emptyAnimationView.isHidden = true
        }
    }
    
    //MARK: - UI Bindings
    
    private func bindTableView() {
        
        isFavoritesEmpty(animate: true)
        
        let object = favoritesViewModel?.moviesListData
        guard let object else { return }
        
        object
            .asDriver()
            .drive(favoritesTableView
                .rx
                .items(cellIdentifier: K.Identifiers.favoritesCell,
                       cellType: FavoritesTableViewCell.self)) { _, data, cell in
                
                self.isFavoritesEmpty(animate: false)
                
                self.title = self.favoritesViewModel?.listName.value
                cell.selectionStyle = .none
                cell.configureCell(with: data)
            }.disposed(by: disposeBag)
        
        // Notifies which object in has been selected in the TableView
        favoritesTableView.rx.modelSelected(FavoritesMoviesCacheModel.self)
            .asDriver()
            .drive(onNext: { [weak self] value in
                guard let self else { return }
                
                //self.coordinator?.parentCoordinator?.goToDetails(with: value.id)
                self.coordinator?.goToDetails(with: value.id)
            }).disposed(by: disposeBag)
        
        // Notifies which object in has been deleted in the TableView
        favoritesTableView.rx.modelDeleted(FavoritesMoviesCacheModel.self)
            .asDriver()
            .drive(onNext: { [weak self] item in
                guard let self else { return }
                
                self.favoritesViewModel?.deleteMovie(with: item.id)
                self.favoritesViewModel?.getMovieListData()
                
                if object.value.isEmpty {
                    self.isFavoritesEmpty(animate: true)
                }
            }).disposed(by: disposeBag)
    }
    
}

//MARK: - Extensions

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
}

