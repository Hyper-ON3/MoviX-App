//
//  FilmsByGenreViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 16/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol FilmsByGenreProtocol {
    
    var genreInfo: GenreList? { get set }
    var filmsArray: BehaviorRelay<[FilmsListModel]> { get }
    
    func getFilms()
    func fetchMoreFilms(index: Int, tableView: UITableView, activityInticator: UIView)
}

class FilmsByGenreViewModel: FilmsByGenreProtocol {
    
    var genreInfo: GenreList?
    let filmsArray = BehaviorRelay<[FilmsListModel]>(value: [])
    let disposeBag = DisposeBag()
    
    private var currentPage = 1
    private var totalPages = 0
    
    func getFilms() {
        
        MoviesClient.getMoviesByGenre(id: genreInfo?.id ?? 0, from: currentPage)
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { films in
                
                guard let films else { return }
                
                self.totalPages = films.totalPages ?? 1
                
                let result = films.results?.compactMap({ film in
                    FilmsListModel(id: film.id,
                                   posterPath: film.posterPath ?? "",
                                   title: film.title,
                                   voteAverage: film.voteAverage,
                                   releaseDate: film.releaseDate ?? "")

                })
                
                self.filmsArray.accept(self.filmsArray.value + (result ?? []))
            })
            .disposed(by: disposeBag)
    }
    
    // Function for pagination
    func fetchMoreFilms(index: Int, tableView: UITableView, activityInticator: UIView) {
        
        if index == (filmsArray.value.count - 1), currentPage <= totalPages {
            
            self.currentPage += 1
            tableView.tableFooterView = activityInticator
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getFilms()
            }
            
        } else if currentPage > totalPages {
            tableView.tableFooterView = nil
        }
    }
    
}
