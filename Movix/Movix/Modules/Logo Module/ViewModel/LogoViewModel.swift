//
//  LogoViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 31/01/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol LogoViewModelProtocol: AnyObject {
    
    func checkNetworkStatus(_ coordinator: MainCoordinator?)
}

class LogoViewModel: LogoViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private var networkCheck = NetworkCheck.sharedInstance()
    
    // Сhecking whether the user is logged in
    private func authCheck() -> LoginModel? {
        
        guard let login = KeychainManager.get(key: .login), let password = KeychainManager.get(key: .password) else { return nil }
        
        let loginData = LoginModel(login: String(data: login, encoding: .utf8) ?? "",
                                   password: String(data: password, encoding: .utf8) ?? "",
                                   isChecked: true)
        
        return loginData
    }
    
    private func logIn(coordinator: MainCoordinator?) {
        
        guard let userData = authCheck() else { coordinator?.goTo(screen: .login); return }
        
        AuthClient.verifyingUserData(with: userData) { response in
            
            if response == "" {
                coordinator?.goTo(screen: .home)
            } else {
                coordinator?.goTo(screen: .login)
            }
        }
    }
    
    func checkNetworkStatus(_ coordinator: MainCoordinator?) {
        
        if networkCheck.currentStatus == .satisfied {
            logIn(coordinator: coordinator)
        } else {
            coordinator?.goTo(screen: .home)
        }
    }
    
}

