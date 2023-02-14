//
//  AuthClient.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 30/01/2023.
//

import Foundation
import Alamofire
import RxSwift

class AuthClient {
    
    private static func performRequest<T: Codable>(route: AuthEndpoint,
                                                   model: T.Type,
                                                   completion: @escaping (DataResponse<T, AFError>?) -> Void) {
        
        AF.request(route).responseDecodable(of: model.self) { response in
            completion(response)
        }
    }
    
    //MARK: - 1. Request Token for auth
    static func getRequestToken(completion: @escaping ((String) -> Void)) {
        
        performRequest(route: .getRequestToken,
                       model: TokenRequestModel.self) { response in
            
            switch response?.result {
            case .success(let data):
                completion(data.requestToken)
            case .failure(let error):
                ServiceManager.shared.errorMessage = error.localizedDescription
                print(error)
            default: return
            }
        }
    }
    
    //MARK: - 2. Verifying User Data
    static func verifyingUserData(with params: LoginModel, completion: ((String) -> Void)?)  {
        
        getRequestToken { token in
            performRequest(route: .verifyingUserData(params: params, requestToken: token),
                           model: ValidationModel.self) { response in
                
                guard let response = response?.value else { return }
                
                if response.success != false {
                    completion?("")
                    self.createUserSession(with: response.requestToken ?? "")
                } else {
                    ServiceManager.shared.errorMessage = response.statusMessage ?? ""
                    completion?(response.statusMessage ?? "Error")
                }
            }
        }
    }
    
    //MARK: - 3. Create User Session
    static func createUserSession(with requestToken: String) {
        
        performRequest(route: .createUserSession(requestToken: requestToken),
                       model: SessionModel.self) { response in
            
            guard let data = response?.value else { return }
            
            if data.success == true {
                ServiceManager.shared.sessionId = data.sessionID ?? ""
                self.getAccountDetails(with: data.sessionID ?? "")
            } else {
                ServiceManager.shared.errorMessage = "CreateUserSession went wrong! Session denied."
            }
        }
    }
    
    //MARK: - 4. Get Account Details
    static func getAccountDetails(with sessionId: String) {
        
        performRequest(route: .getAccountDetails(sessionId: sessionId),
                       model: GetAccountDetailsModel.self) { response in
            
            guard let response = response else { return }
            
            switch response.result {
            case .success(let data):
                ServiceManager.shared.userDetails.accept(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
