//
//  KeychainManager.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 31/01/2023.
//

import Foundation

enum KeychainKey: String {
    case login = "login"
    case password = "password"
}

class KeychainManager {
    
    static func save(key: KeychainKey, data: String) {
        
        let data = data.data(using: .utf8)
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue as AnyObject,
            kSecValueData as String: data as AnyObject,
        ]
        SecItemDelete(query as CFDictionary)
        print("Saved")
        SecItemAdd(query as CFDictionary, nil)
    }
    
    static func get(key: KeychainKey) -> Data? {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
       
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        print(status)
        
        return result as? Data
    }
    
    static func logout() {
        
        let secItemClasses = [kSecClassGenericPassword]
        
        for item in secItemClasses {
            let spec: NSDictionary = [kSecClass: item]
            SecItemDelete(spec)
        }
    }

}
