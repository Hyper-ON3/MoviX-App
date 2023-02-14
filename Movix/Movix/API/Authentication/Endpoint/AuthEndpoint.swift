//
//  AuthEndpoint.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 30/01/2023.
//

import Foundation
import Alamofire

enum AuthEndpoint: APIConfiguration {
    
    case getRequestToken
    case verifyingUserData(params: LoginModel, requestToken: String)
    case createUserSession(requestToken: String)
    case getAccountDetails(sessionId: String)
    
    var method: HTTPMethod {
        switch self {
        case .getRequestToken, .getAccountDetails:
            return .get
        case .verifyingUserData, .createUserSession:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getRequestToken:
            return K.API.baseURL + "/authentication/token/new?api_key=" + K.API.apiKey
        case .verifyingUserData:
            return K.API.baseURL + "/authentication/token/validate_with_login?api_key=" + K.API.apiKey
        case .createUserSession:
            return K.API.baseURL + "/authentication/session/new?api_key=" + K.API.apiKey
        case.getAccountDetails(let sessionId):
            return K.API.baseURL + "/account?api_key=" + K.API.apiKey + "&session_id=" + sessionId
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .verifyingUserData(let params, let requestToken):
            return ["username": params.login,
                    "password": params.password,
                    "request_token": requestToken]
            
        case .createUserSession(let requestToken):
            return ["request_token": requestToken]
            
        case .getRequestToken, .getAccountDetails:
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
                let httpBody = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.httpBody = httpBody
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
       
        return urlRequest
    }
    
    
}
