//
//  GenresViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 12/01/2023.
//

import UIKit
import Lottie
import RxDataSources
import RxSwift
import RxCocoa
import RxRelay
import Network

class HomeViewController: UIViewController, Storyboarded {

    @IBOutlet weak var genresCollectionView: UICollectionView!
    @IBOutlet weak var filmsTableView: UITableView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var noInternetAnimationView: LottieAnimationView!
    
    var coordinator: HomeCoordinator?
    private let disposeBag = DisposeBag()
    var homeViewModel: HomeViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindCollectionView()
        bindTableView()
        bindUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeViewModel?.checkNetworkStatus(completion: { status in
            if status == true {
                self.homeViewModel?.getAccountDetails()
                self.configureUI()
            } else {
                self.noInternetAnimation(animated: true)
            }
        })
    }

    //MARK: - UI Configuration functions
    
    private func configureUI() {
        
        title = K.Titles.moviesView
        
        noInternetAnimationView.isHidden = true
        self.noInternetLabel.isHidden = true
                
        //filmsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        homeViewModel?.getGenres()
    }
    
    //MARK: - Animation functions
    
    private func noInternetAnimation(animated: Bool) {
        
        noInternetAnimationView.loopMode = .autoReverse
        
        if animated == true {
            title = K.Titles.favoritesMovie
            self.noInternetAnimationView.isHidden = false
            self.filmsTableView.isHidden = true
            self.categoryLabel.isHidden = true
            self.noInternetLabel.isHidden = false
            noInternetAnimationView.play()
        } else {
            noInternetAnimationView.stop()
            noInternetAnimationView.isHidden = true
        }
    }
    
    //MARK: - UI Bindings
    
    private func bindCollectionView() {
        
        let object = homeViewModel?.genresArray
        guard let object else { return }
        
        // Binding an object to Genres CollectionView
        object
            .asDriver()
            .drive(genresCollectionView
            .rx
            .items(cellIdentifier: K.Identifiers.genreCell,
                   cellType: GenreCollectionViewCell.self)) { _, genre, cell in
                
            cell.confugureElements(with: genre)

        }.disposed(by: disposeBag)
        
        // Notifies which object in has been selected in the CollectionView
        genresCollectionView.rx.modelSelected(GenreList.self)
            .asDriver()
            .drive(onNext: { [weak self] genre in
            guard let self else { return }
            
                self.coordinator?.goToFilmsByGenre(with: genre)
        }).disposed(by: disposeBag)
    }
    
    private func bindUserDetails() {
        
        let object = homeViewModel?.accountDetails
        guard let object else { return }
        
        object
            .asDriver()
            .drive(onNext: { [weak self] data in
            guard let self else { return }
            
            self.greetingLabel.text = "Hello, \(data.username) 😊"
        }).disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        
        let object = homeViewModel?.filmsArray
        guard let object else { return }
        
        homeViewModel?.showFilms()

        object
            .asDriver()
            .drive(filmsTableView.rx.items(dataSource: dataSourse()))
            .disposed(by: disposeBag)
    }
    
    //MARK: - IBActions
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        homeViewModel?.logout(coordinator?.parentCoordinator)
        coordinator?.didFinishHome()
    }
}

//MARK: - Extensions
extension HomeViewController {
    
    func dataSourse() -> RxTableViewSectionedReloadDataSource<FilmsCategory> {
        
        return RxTableViewSectionedReloadDataSource<FilmsCategory>(configureCell: { dataSourse, tableView, indexPath, item in
            
            guard
                let cell: FilmsTableViewCell = (tableView.dequeueReusableCell(withIdentifier: K.Identifiers.filmsTableViewCell,
                                                                              for: indexPath) as? FilmsTableViewCell)
            else { return UITableViewCell() }
            
            Observable.just(item.items)
                .asDriver(onErrorJustReturn: [])
                .drive(cell.filmsCollectionView
                    .rx
                    .items(cellIdentifier: K.Identifiers.filmsCollectionViewCell,
                           cellType: FilmInfoCollectionViewCell.self)) { _, element, cell in
                    
                    cell.configureCell(with: element)
                }.disposed(by: cell.disposeBag)
            
            // Notifies which object in has been selected in the CollectionView
            cell.filmsCollectionView.rx.modelSelected(FilmsCategoryModel.self)
                .asDriver()
                .drive(onNext: { [weak self] info in
                guard let self else { return }
                
                    self.coordinator?.goToDetails(with: info.id)
            }).disposed(by: cell.disposeBag)
            
            return cell
            
        }, titleForHeaderInSection: { dataSourse, index in
            
            return dataSourse.sectionModels[index].header
            
        })
    }
}
