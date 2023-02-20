//
//  MoviesEndpoint.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 30/01/2023.
//

import Foundation
import Alamofire

enum MoviesEndpoint: APIConfiguration {
    
    case fetchGnres
    case moviesByGenre(id: Int, page: Int)
    case fetchFilms(url: String)
    case filmDetails(id: Int)
    case trailerDetails(id: Int)
    case searchFilm(page: Int, query: String)
    
    var method: HTTPMethod {
        
        switch self {
        case .fetchGnres,
                .moviesByGenre,
                .fetchFilms,
                .filmDetails,
                .trailerDetails,
                .searchFilm:
            return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .fetchGnres:
            return K.API.baseURL + "/genre/movie/list?api_key=" + K.API.apiKey + "&language=en-US"
        case .moviesByGenre(let id, let page):
            return K.API.baseURL + "/discover/movie?api_key=" + K.API.apiKey + "&with_genres=" + String(id) + "&page=\(page)"
        case .fetchFilms(let url):
            return url
        case .filmDetails(let id):
            return K.API.baseURL + "/movie/\(id)?api_key=" + K.API.apiKey
        case .trailerDetails(let id):
            return K.API.baseURL + "/movie/\(id)/videos?api_key=" + K.API.apiKey
        case .searchFilm(let page, let query):
            return "\(K.API.baseURL)/search/movie?api_key=\(K.API.apiKey)&language=en-US&query=\(query)&page=\(page)"
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .fetchGnres,
                .moviesByGenre,
                .fetchFilms,
                .filmDetails,
                .trailerDetails,
                .searchFilm:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: path) ?? URL(string: "")!
        
        var urlRequest = URLRequest(url: url)
   
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.addValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HTTPHeaderField.contentType.rawValue)
        urlRequest.addValue(K.ContentType.json.rawValue, forHTTPHeaderField: K.HTTPHeaderField.acceptType.rawValue)
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
    
}
