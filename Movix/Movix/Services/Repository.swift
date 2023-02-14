//
//  Repository.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation
import RealmSwift
import RxSwift

protocol RepositoryProtocol {
    
    func cacheMovieDetails()
    func getFavoritesMoviesData<T: Object>(of type: T.Type) -> Array<T>
    func deleteCache<T:Object>(of type: T.Type, with id: Int)
}

struct Repository: RepositoryProtocol {
    
    var dbManager: DBManagerProtocol?
    private let disposeBag = DisposeBag()
    
    func cacheMovieDetails() {
        
        guard let dbManager = dbManager else { return }
        
        MoviesListClient.getMoviesListDetails()
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { data in
                
                guard let data else { return }
                
                for item in data.items {
                    dbManager.save(data: FavoritesMoviesCacheModel(id: item.id,
                                                                   backdropPath: item.backdropPath,
                                                                   listName: data.name,
                                                                   filmName: item.title))
                    
                    MoviesClient.getFilmDetails(with: item.id)
                        .asDriver(onErrorJustReturn: nil)
                        .drive(onNext: { details in
                            
                            guard let details else { return }
                            
                            let detailsArray = [String(details.releaseDate), details.productionCountries?.first??.name ?? "", String(details.runtime)]
                            
                            // Converts ordinary data into Realm data
                            let infoList = List<String>()
                            infoList.append(objectsIn: detailsArray)
                            
                            let genresList = List<MovieGenres>()
                            for genre in details.genres {
                                genresList.append(MovieGenres(id: genre.id, name: genre.name))
                            }
                            
                            dbManager.save(data: FavoriteMovieDetailsCacheModel(id: details.id,
                                                                                backdropPath: details.posterPath ?? "",
                                                                                filmName: details.title,
                                                                                genres: genresList,
                                                                                filmInfo: infoList,
                                                                                filmRating: ServiceManager.shared.setRating(details.voteAverage),
                                                                                about: details.overview ?? "",
                                                                                status: details.status))
                            
                        }).disposed(by: disposeBag)
                }
            }).disposed(by: disposeBag)
    }
    
    func getFavoritesMoviesData<T: Object>(of type: T.Type) -> Array<T>  {
        
        let result = dbManager?.obtainData(of: type.self)
        
        return result ?? []
        
    }
    
    func deleteCache<T:Object>(of type: T.Type, with id: Int) {
        
        dbManager?.deleteItem(of: type, with: id)
        
        MoviesListClient.removeMovie(with: id)
    }
}
