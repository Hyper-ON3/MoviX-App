//
//  APIConfiguration.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 30/01/2023.
//

import Alamofire

protocol APIConfiguration: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}
