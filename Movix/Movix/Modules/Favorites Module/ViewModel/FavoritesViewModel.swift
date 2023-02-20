//
//  FavoritesViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 02/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol FavoritesViewModelProtocol {
    
    var listName: BehaviorRelay<String> { get }
    var moviesListData: BehaviorRelay<[FavoritesMoviesCacheModel]> { get }

    func loadFavoriteMovies() 
    func getMovieListData()
    func deleteMovie(with id: Int)
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let repository: RepositoryProtocol?
    var moviesListData = BehaviorRelay<[FavoritesMoviesCacheModel]>(value: [])
    var listName = BehaviorRelay<String>(value: "")
    
    init(repository: RepositoryProtocol?) {
        self.repository = repository
    }
    
    //MARK: - Functions 
    
    func loadFavoriteMovies() {
        
        repository?.cacheMovieDetails()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.getMovieListData()
        }
    }
    
    func getMovieListData() {
        
        guard let repository = repository else { return }
    
        let result = repository.getFavoritesMoviesData(of: FavoritesMoviesCacheModel.self)
        
        if !result.isEmpty {
            listName.accept(result[0].listName)
        }
        
        moviesListData.accept(result)
    }
    
    func deleteMovie(with id: Int) {
    
        repository?.deleteCache(of: FavoritesMoviesCacheModel.self, with: id)
        repository?.deleteCache(of: FavoriteMovieDetailsCacheModel.self, with: id)
    }
}
