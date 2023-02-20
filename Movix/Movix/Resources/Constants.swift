//
//  Constants.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 11/01/2023.
//

import Foundation

struct K {
    
    struct API {
        
        static let baseURL = "https://api.themoviedb.org/3"
        static let apiKey = "624f26bb0f43851b0be0c7a23c5155d0"
        
        static let getPosterImage = "https://image.tmdb.org/t/p/w500"
        
        static let nowPlayingFilms = baseURL + "/movie/now_playing?api_key=" + apiKey + "&language=en-US&page=1"
        static let popularFilms = baseURL + "/movie/popular?api_key=" + apiKey + "&language=en-US&page=1"
        static let topRatedFilms = baseURL + "/movie/top_rated?api_key=" + apiKey + "&language=en-US&page=1"
        static let upcomingFilms = baseURL + "/movie/upcoming?api_key=" + apiKey + "&language=en-US&page=1"
        
    }
    
    struct Identifiers {
        
        static let genreCell = "GenreCollectionViewCell"
        static let filmsTableViewCell = "FilmsTableVIewCell"
        static let filmsCollectionViewCell = "FilmInfoCollectionViewCell"
        static let filmsByGenreCell = "FimsByGenreCell"
        static let searchCell = "SearchCollectionViewCell"
        static let searchQueryCell = "SearchQueryTableViewCell"
        static let favoritesCell = "FavoritesTableViewCell"
    }
    
    struct Titles {
        
        static let appName = "MoviX"
        static let moviesView = "Movies"
        static let filmDetails = "Film Details"
        static let favoritesMovie = "Favorite Movie"
        static let searchMovies = "Search"
    }
    
    struct Keys {
        
        static let listId = 8238612
        static let searchQueriesKey = "searchQuery"
    }
    
    struct ImagesName {
        
        static let noImage = "noImage"
        static let checkImage = "check"
        
        static let home = "home"
        static let homeSelected = "homeSelected"
        static let homeBig = "home-4"
        static let homeBigSelected = "home-5"
        static let search = "search"
        static let searchSelected = "searchSelected"
        static let favorites = "favorites"
        static let favoritesSelected = "favoritesSelected"
        
        
    }
    
    enum HTTPHeaderField: String {
        
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    enum ContentType: String {
        
        case json = "application/json"
    }
}
