//
//  MoviesListEndpoint.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation
import Alamofire

enum MoviesListEndpoint: APIConfiguration {
    
    case checkItemStatus(moviewId: Int)
    case addFilmToList(id: Int)
    case getMoviesListDetails
    case removeMovie(id: Int)
    
    var method: HTTPMethod {
        
        switch self {
        case .addFilmToList, .removeMovie:
            return .post
        case .getMoviesListDetails, .checkItemStatus:
            return .get
        }
    }
    
    var path: String {
        
        switch self {
        case .checkItemStatus(let movieId):
            return "\(K.API.baseURL)/list/\(K.Keys.listId)/item_status?api_key=\(K.API.apiKey)&movie_id=\(movieId)"
        case .addFilmToList:
            return "\(K.API.baseURL)/list/\(K.Keys.listId)/add_item?api_key=\(K.API.apiKey)&session_id=\(ServiceManager.shared.sessionId)"
        case .getMoviesListDetails:
            return "\(K.API.baseURL)/list/\(K.Keys.listId)?api_key=\(K.API.apiKey)&language=en-US"
        case .removeMovie:
            return "\(K.API.baseURL)/list/\(K.Keys.listId)/remove_item?api_key=\(K.API.apiKey)&session_id=\(ServiceManager.shared.sessionId)"
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .addFilmToList(let id):
            return ["media_id": id]
        case .removeMovie(let id):
            return ["media_id": id]
        case .getMoviesListDetails, .checkItemStatus:
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
