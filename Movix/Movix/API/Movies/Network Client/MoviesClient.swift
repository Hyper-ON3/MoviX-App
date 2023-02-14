//
//  MoviesClient.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 30/01/2023.
//

import Foundation
import Alamofire
import RxSwift

class MoviesClient {

    private static func performRequest<T: Codable>(route: MoviesEndpoint,
                                                   model: T.Type,
                                                   completion: @escaping (T) -> Void) -> DataRequest {

        return AF.request(route).responseDecodable(of: model.self) { response in

            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getGenres() -> Observable<[Genre]> {
        
        return Observable.create { observer in
            let request = performRequest(route: .fetchGnres, model: GenreModel.self) { data in
                
                observer.onNext(data.genres)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func getMoviesByGenre(id: Int, from page: Int) -> Observable<FilmsByGenreModel?> {
        
        return Observable.create { observer in
            let request = performRequest(route: .moviesByGenre(id: id, page: page),
                                         model: FilmsByGenreModel.self) { data in
                
                observer.onNext(data)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func fetchFilms(fromURL url: String) -> Observable<[Result]> {
        return Observable.create { observer in
            let request = performRequest(route: .fetchFilms(url: url),
                                         model: FilmsByGenreModel.self) { data in
                
                observer.onNext(data.results ?? [])
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func getFilmDetails(with id: Int) -> Observable<FilmDetailsModel?> {
        
        return Observable.create { observer in
            let request = performRequest(route: .filmDetails(id: id),
                                         model: FilmDetailsModel.self) { data in
                
                observer.onNext(data)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func getTrailerDetails(with id: Int) -> Observable<String> {
        
        return Observable.create { observer  in
            let request = performRequest(route: .trailerDetails(id: id),
                                         model: GetTrailerModel.self) { data in
                
                for i in data.results {
                    if i.type == "Trailer" {
                        observer.onNext(i.key)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    static func searchFilm(page: Int, query: String) -> Observable<FilmsByGenreModel?> {
        
        return Observable.create { observer in
            let request = performRequest(route: .searchFilm(page: page, query: query),
                                         model: FilmsByGenreModel.self) { data in
                
                observer.onNext(data)
                observer.onCompleted()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }


}
