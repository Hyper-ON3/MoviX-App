//
//  GenresViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 12/01/2023.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

//MARK: - Enum
enum FilmType: String {
    
    case nowPlayingFilms = "Now playing films"
    case popularFilms = "Popular films"
    case topRatedFilms = "Top rated films"
    case upcomingFilms = "Upcoming films"
}

//MARK: - Protocol

protocol HomeViewModelProtocol: AnyObject {
    
    var genresArray: BehaviorRelay<[GenreList]> { get }
    var filmsArray: BehaviorRelay<[FilmsCategory]> { get }
    var accountDetails: BehaviorRelay<GetAccountDetailsModel> { get }
    
    func getGenres()
    func showFilms()
    func getAccountDetails()
    func logout(_ coordinator: MainCoordinator?)
    func checkNetworkStatus(completion: @escaping ((Bool) -> Void))

}

//MARK: - Class

class HomeViewModel: HomeViewModelProtocol {
   
    let disposeBag = DisposeBag()
    var genresArray = BehaviorRelay<[GenreList]>(value: [])
    var filmsArray = BehaviorRelay<[FilmsCategory]>(value: [])
    var accountDetails = BehaviorRelay<GetAccountDetailsModel>(value: GetAccountDetailsModel(id: 0,
                                                                                             name: "",
                                                                                             includeAdult: false,
                                                                                             username: ""))
    private var networkCheck = NetworkCheck.sharedInstance()
    //var networkManager = NetworkManager()
    
    func getGenres() {
        
        MoviesClient.getGenres()
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { genre in
                let result = genre.compactMap { genre in
                    GenreList(id: genre.id, genreName: genre.name, genreImage: UIImage(named: genre.name) ?? UIImage())
                }
                self.genresArray.accept(result)
            })
            .disposed(by: disposeBag)
    }
    
    func showFilms() {
        
        fetchFilms(fromURL: .nowPlayingFilms)
        fetchFilms(fromURL: .popularFilms)
        fetchFilms(fromURL: .topRatedFilms)
        fetchFilms(fromURL: .upcomingFilms)
    }
    
    private func fetchFilms(fromURL url: FilmType) {
        
        var filmUrl = ""
        var filmType = ""
        
        switch url {
        case .nowPlayingFilms:
            filmUrl = K.API.nowPlayingFilms
            filmType = FilmType.nowPlayingFilms.rawValue
        case .popularFilms:
            filmUrl = K.API.popularFilms
            filmType = FilmType.popularFilms.rawValue
        case .topRatedFilms:
            filmUrl = K.API.topRatedFilms
            filmType = FilmType.topRatedFilms.rawValue
        case .upcomingFilms:
            filmUrl = K.API.upcomingFilms
            filmType = FilmType.upcomingFilms.rawValue
        }
        
        MoviesClient.fetchFilms(fromURL: filmUrl)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { films in
                let result = films.compactMap { film in
                    FilmsCategoryModel(id: film.id,
                                       posterPath: film.posterPath ?? "",
                                       releaseDate: film.releaseDate ?? "",
                                       title: film.title,
                                       voteAverage: String(film.voteAverage))
                }
                let sections: [FilmsCategory] = [FilmsCategory(header: filmType,
                                                               items: [FilmsCategoryItem(items: result)])]
                
                self.filmsArray.accept(self.filmsArray.value + sections)
                
                
            })
            .disposed(by: disposeBag)
    }
    
    func getAccountDetails() {
        
        ServiceManager.shared.userDetails
            .asDriver()
            .drive(onNext: { data in
            
            self.accountDetails.accept(GetAccountDetailsModel(id: data.id,
                                                         name: data.name,
                                                         includeAdult: data.includeAdult,
                                                         username: data.username))
        }).disposed(by: disposeBag)
    }
    
    func logout(_ coordinator: MainCoordinator?) {
        
        KeychainManager.logout()
        ServiceManager.shared.sessionId = ""
        coordinator?.goTo(screen: .login)
    }
    
    func checkNetworkStatus(completion: @escaping ((Bool) -> Void)) {

        if networkCheck.currentStatus == .satisfied{
            completion(true)
        } else{
            completion(false)
        }
    }
}

