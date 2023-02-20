//
//  DetailsViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 20/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol DetailsViewModelProtocol {
    
    var filmId: Int? { get set }
    var details: BehaviorRelay<DetailsModel> { get }
    var trailerInfo: BehaviorRelay<TrailerModel> { get }
    
    func getDetails()
    func addFimlToList(with id: Int)
    func checkNetworkStatus(completion: ((Bool) -> Void))
    func isMovieInList(with id: Int, completion: @escaping ((Bool) -> Void))
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private var repository: RepositoryProtocol?
    
    var filmId: Int?
    var trailerInfo = BehaviorRelay<TrailerModel>(value: TrailerModel(trailerID: ""))
    var details = BehaviorRelay<DetailsModel>(value: DetailsModel(id: 0,
                                                                  backdropPath: "",
                                                                  filmName: "",
                                                                  genres: [],
                                                                  filmInfo: [],
                                                                  filmRating: "",
                                                                  about: "",
                                                                  status: ""))
    
    init(repository: RepositoryProtocol?) {
        self.repository = repository
    }
    
    //MARK: - Functions 
    
    func getDetails() {
        
        fetchMovieDetails()
        
        let favoritesCache = repository?.getFavoritesMoviesData(of: FavoriteMovieDetailsCacheModel.self)
        
        // Checks if there are details of this movie in the cache
        for item in (favoritesCache ?? []) where item.id == filmId {
            
            // Сonverts realm data to regular data
            var genres: [Genres] = []
            for item in item.genres {
                genres.append(Genres(id: item.id, name: item.name))
            }
            
            var filmInfo: [String] = []
            for item in item.filmInfo {
                filmInfo.append(item)
            }
            
            details.accept(DetailsModel(id: item.id,
                                        backdropPath: item.backdropPath,
                                        filmName: item.filmName,
                                        genres: genres,
                                        filmInfo: filmInfo,
                                        filmRating: item.filmRating,
                                        about: item.about,
                                        status: item.status))
        }
    }
    
    func addFimlToList(with id: Int) {
        MoviesListClient.addFilmToList(id: id)
    }
    
    private func fetchMovieDetails() {
        
        MoviesClient.getFilmDetails(with: filmId ?? 0)
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { data in
                
                guard let data else { return }
                
                MoviesClient.getTrailerDetails(with: data.id)
                    .subscribe(onNext: { id in
                        self.trailerInfo.accept(TrailerModel(trailerID: id))
                    }).disposed(by: self.disposeBag)
                
                let filmInfo = [String(data.releaseDate),
                                data.productionCountries?.first??.name ?? "",
                                String(data.runtime)]
                
                self.details.accept(DetailsModel(id: data.id,
                                                 backdropPath: data.posterPath ?? "",
                                                 filmName: data.title,
                                                 genres: data.genres,
                                                 filmInfo: filmInfo ,
                                                 filmRating: ServiceManager.shared.setRating(data.voteAverage),
                                                 about: data.overview ?? "",
                                                 status: data.status))
            }).disposed(by: disposeBag)
    }
    
    func checkNetworkStatus(completion: ((Bool) -> Void)) {
        
        if NetworkMonitor.shared.isConnected {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // Сhecks if the movie has been added to favorites
    func isMovieInList(with id: Int, completion: @escaping ((Bool) -> Void)) {
        
        MoviesListClient.checkItemStatus(with: id) { status in
            completion(status)
        }
    }
}

