//
//  SearchViewModel.swift
//  
//
//  Created by Aleksey Kotsevych on 24/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol SearchViewModelProtocol {
    
    var filmsData: BehaviorRelay<[SearchModelResult]> { get }
    var lastSearchQueries: BehaviorRelay<[String]> { get }
    
    func fetchSavedSearchQueries()
    func getFilmsList(with query: String)
    func saveSearchQuery(_ query: String)
    func fetchMoreFilms(index: Int, collectionView: UICollectionView, activityInticator: UIActivityIndicatorView?)
    func updateFilmsData()
    func checkNetworkStatus(completion: ((Bool) -> Void))
}

class SearchViewModel: SearchViewModelProtocol {
    
    //MARK: - Instances
    
    var filmsData = BehaviorRelay<[SearchModelResult]>(value: [])
    var lastSearchQueries = BehaviorRelay<[String]>(value: [])
    
    private let disposeBag = DisposeBag()
    private var saveSearchQueries: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: K.Keys.searchQueriesKey) ?? []
        }
        set {
            let defaults = UserDefaults.standard
         
            defaults.set(newValue, forKey: K.Keys.searchQueriesKey)
        }
    }
    private var request: String?
    private var currentPage = 1
    private var totalPages = 0
    
    //MARK: - Functions
    
    func fetchSavedSearchQueries() {
        lastSearchQueries.accept(saveSearchQueries)
    }
    
    func getFilmsList(with request: String) {
        
        self.request = request
        
        MoviesClient.searchFilm(page: currentPage, query: request)
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { values in
                
                guard let values else { return }
                
                self.totalPages = values.totalPages ?? 1
                
                let result = values.results?.compactMap { data in
                    SearchModelResult(id: data.id,
                                      posterPath: data.posterPath ?? "",
                                      filmsName: data.title)
                }
                self.filmsData.accept(self.filmsData.value + (result ?? []))
            }).disposed(by: disposeBag)
    }
    
    // Function for pagination
    func fetchMoreFilms(index: Int, collectionView: UICollectionView, activityInticator: UIActivityIndicatorView?) {
        
        if index == (filmsData.value.count - 1), currentPage < totalPages {
            
            currentPage += 1
            
            activityInticator?.isHidden = false
            activityInticator?.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.request != nil {
                    self.getFilmsList(with: self.request ?? "")
                    activityInticator?.stopAnimating()
                    activityInticator?.isHidden = true
                }
            }
        } else if currentPage > totalPages {
            activityInticator?.stopAnimating()
            return
        }
    }
    
    // Сlears search results
    func updateFilmsData() {
        filmsData.accept([])
        currentPage = 1
        print()
    }
    
    // Saves the user's search queries in UserDefaults
    func saveSearchQuery(_ query: String) {
        
        if lastSearchQueries.value.count < 5 && saveSearchQueries.count < 5 {
            
            saveSearchQueries.insert(query, at: 0)
            lastSearchQueries.accept(saveSearchQueries)
        } else {
            
            saveSearchQueries.removeLast()
            saveSearchQueries.insert(query, at: 0)
            
            lastSearchQueries.accept(saveSearchQueries)
        }
    }
    
    func checkNetworkStatus(completion: ((Bool) -> Void)) {
        
        if NetworkMonitor.shared.isConnected {
            completion(true)
        } else {
            completion(false)
        }
    }
}
