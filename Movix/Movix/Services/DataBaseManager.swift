//
//  DataBaseManager.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 03/02/2023.
//

import Foundation
import RealmSwift

protocol DBManagerProtocol {
    
    func save<T: Object>(data: T)
    func obtainData<T: Object>(of type: T.Type) -> Array<T>
    func deleteItem<T: Object, K>(of type: T.Type, with id: K)
}

class DBManager: DBManagerProtocol {
    
    private lazy var realm = try! Realm()
    
    func save<T: Object>(data: T) {
        
        try! realm.write({
            realm.add(data, update: .all)
        })
    }
    
    func obtainData<T: Object>(of type: T.Type) -> Array<T> {
        
        let result = realm.objects(type.self)
        
        return Array(result)
    }
    
    func deleteItem<T: Object, K>(of type: T.Type, with id: K) {
        
        let deleteObject = realm.object(ofType: type.self, forPrimaryKey: id)
        
        if deleteObject != nil {
            try! realm.write({
                realm.delete(deleteObject!)
                
            })
        }
    }
    
}
