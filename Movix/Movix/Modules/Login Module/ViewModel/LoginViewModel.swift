//
//  LoginViewModel.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 11/01/2023.
//

import UIKit

protocol LoginViewModelProtocol: AnyObject {
    
    func getUserData(with data: LoginModel)
    func saveUserData(_ sender: AnyObject)
    func logIn(coordinator: MainCoordinator?)
}

class LoginViewModel: LoginViewModelProtocol {
    
    private var userData: LoginModel?
    private var isChecked: Bool = false
    
    func getUserData(with data: LoginModel) {
        
        userData = data
    }
    
    func logIn(coordinator: MainCoordinator?) {
        
        guard let userData else { return }
        
        // Checks the user's login and password
        AuthClient.verifyingUserData(with: userData) { response in
            
            if response == "" {
                coordinator?.goTo(screen: .home)
            }
        }
    }
    
    // Checking whether the user wants to save the login and password
    func saveUserData(_ sender: AnyObject) {
        
        if isChecked == false {
            sender.setBackgroundImage(UIImage(named: K.ImagesName.checkImage), for: .normal)
            saveDataToKeychain(true)
            isChecked = true
        } else {
            sender.setBackgroundImage(UIImage(), for: .normal)
            saveDataToKeychain(false)
            isChecked = false
        }
    }
    
    // Saving the user login and password in the keychain
    private func saveDataToKeychain(_ save: Bool) {
        
        guard let userData else { return }
    
        if save == true {
            KeychainManager.save(key: .login, data: userData.login)
            KeychainManager.save(key: .password, data: userData.password)
        } else {
            KeychainManager.logout()
        }
    }
    
}
