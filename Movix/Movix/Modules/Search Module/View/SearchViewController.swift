//
//  SearchViewController.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 24/01/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class SearchViewController: UIViewController, Storyboarded {

    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var searchQueryTableView: UITableView!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var noInternetAnimationView: LottieAnimationView!
    @IBOutlet weak var searchAnimationView: LottieAnimationView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let searchController = UISearchController()
    var coordinator: SearchCoordinator?
    var searchViewModel: SearchViewModelProtocol?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchViewModel?.checkNetworkStatus(completion: { status in
            if status == true {
                configureUI()
            } else {
                activityIndicator.isHidden = true
                searchAnimation(animated: false)
                noInternetAnimation(animated: true)
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchViewModel?.fetchSavedSearchQueries()
    }

    //MARK: - UI Configuration functions
    
    private func configureUI() {
        title = K.Titles.searchMovies
        
        activityIndicator.isHidden = true
        
        searchCollectionView.delegate = self
        
        searchAnimation(animated: true)
    
        searchController.searchBar.returnKeyType = .go
        
        noInternetAnimationView.isHidden = true
        noInternetLabel.isHidden = true
        
        searchCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
 
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchQueryTableView.delegate = self
        searchQueryTableView.isHidden = true
        
        searchViewModel?.fetchSavedSearchQueries()
        
        bindCollectionView()
        bindTableView()
        searchBarObserver()
    }
    
    //MARK: - Animation functions
    
    private func noInternetAnimation(animated: Bool) {
        
        noInternetAnimationView.loopMode = .autoReverse
        
        if animated == true {
            title = K.Titles.searchMovies
            noInternetAnimationView.isHidden = false
            noInternetLabel.isHidden = false
            warningLabel.isHidden = true
            searchCollectionView.isHidden = true
            noInternetAnimationView.play()
        } else {
            noInternetAnimationView.stop()
            noInternetAnimationView.isHidden = true
            noInternetLabel.isHidden = true
        }
    }
    
    private func searchAnimation(animated: Bool) {
        
        searchAnimationView.loopMode = .autoReverse
        
        if animated == true {
            title = K.Titles.searchMovies
            searchAnimationView.isHidden = false
            warningLabel.isHidden = false
            searchAnimationView.play()
        } else {
            searchAnimationView.stop()
            searchAnimationView.isHidden = true
            warningLabel.isHidden = true
        }
        
    }
    
    //MARK: - UI Bindings
        
    func bindCollectionView() {
        
        let object = searchViewModel?.filmsData
        guard let object = object else { return }
        
        // Checking the query from the search bar and binding it to CollectionView
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({ query in
                self.searchViewModel?.updateFilmsData()
                if query != "" {
                    self.searchAnimation(animated: false)
                    self.searchViewModel?.getFilmsList(with: query.lowercased().replacingOccurrences(of: " ", with: "+"))
                }
                return object.value
            }).asDriver(onErrorJustReturn: [])
            .drive(onNext: { data in
                object.accept(data)
            }).disposed(by: disposeBag)
        
        object
            .asDriver()
            .drive(searchCollectionView
                .rx
                .items(cellIdentifier: K.Identifiers.searchCell, cellType: SearchCollectionViewCell.self)) { _, data, cell in

                    cell.configureCell(with: data)

                }.disposed(by: disposeBag)
    
        // Notifies which object in has been selected in the CollectionView
        searchCollectionView.rx.modelSelected(SearchModelResult.self).subscribe(onNext: { [weak self] value in
            guard let self else { return }
            
            //self.coordinator?.parentCoordinator?.goToDetails(with: value.id)
            self.coordinator?.goToDetails(with: value.id)
        }).disposed(by: disposeBag)
    }
  
    func bindTableView() {
        
        let object = searchViewModel?.lastSearchQueries
        
        guard let object = object else { return }
        
        // Checking the query from the last saved queries and binding it to SearchQueries CollectionView
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map({ query in
                object.value.filter({ lastQueries in
                    query.isEmpty || lastQueries.lowercased().contains(query.lowercased())
                })
            }).asDriver(onErrorJustReturn: [])
            .drive(searchQueryTableView
                .rx
                .items(cellIdentifier: K.Identifiers.searchQueryCell)) { _, data, cell in
                    
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
                    cell.textLabel?.text = data
                    
                }.disposed(by: disposeBag)
        
        // Notifies which object in has been selected and passes the saved search query to the search bar
        searchQueryTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let self else { return }
            
            let cell = self.searchQueryTableView.cellForRow(at: indexPath)
            self.searchController.searchBar.text = cell?.textLabel?.text
        }).disposed(by: disposeBag)
    }
    
    private func searchBarObserver() {
        
        let object = searchViewModel?.filmsData
        guard let object = object else { return }
        
        // Saves the search query if it has been entered
        searchController.searchBar.rx.text
            .asDriver()
            .drive(onNext: { [weak self] query in
            guard let self else { return }
            
            let searchBar = self.searchController.searchBar
            if !searchBar.searchTextField.isEditing && searchBar.text != "" {
                self.searchViewModel?.saveSearchQuery(query ?? "")
            }
        }).disposed(by: disposeBag)
        
        // Observes the text field of the search bar
        searchController.searchBar.rx.textDidBeginEditing
            .asDriver()
            .drive(onNext: { [weak self] _ in
            guard let self else { return }

            self.searchViewModel?.fetchSavedSearchQueries()
            
            if object.value.count != 0 {
                self.searchQueryTableView.isHidden = false
            }

            self.searchViewModel?.updateFilmsData()
            self.searchAnimation(animated: true)
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.textDidEndEditing
            .asDriver()
            .drive(onNext: { [weak self] _ in
            guard let self else { return }
            
            self.searchQueryTableView.isHidden = true
            self.searchController.searchBar.text = ""
        }).disposed(by: disposeBag)
    }
}

//MARK: - Extensions

extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // CollectionView pagination func 
        searchViewModel?.fetchMoreFilms(index: indexPath.row, collectionView: searchCollectionView, activityInticator: activityIndicator)
        
    }
}

