//
//  NetworkCheck.swift
//  Movix
//
//  Created by Aleksey Kotsevych on 08/02/2023.
//

import Foundation
import Network

protocol NetworkCheckProtocol: AnyObject {
    
    func statusDidChange(status: NWPath.Status)
}

class NetworkCheck {
    
    struct NetworkChangeObservation {
         weak var observer: NetworkCheckProtocol?
     }

     private var monitor = NWPathMonitor()
     private static let _sharedInstance = NetworkCheck()
     private var observations = [ObjectIdentifier: NetworkChangeObservation]()
     var currentStatus: NWPath.Status {
         get {
             return monitor.currentPath.status
         }
     }

     class func sharedInstance() -> NetworkCheck {
         return _sharedInstance
     }

     init() {
         monitor.pathUpdateHandler = { [unowned self] path in
             for (id, observations) in self.observations {

                 //If any observer is nil, remove it from the list of observers
                 guard let observer = observations.observer else {
                     self.observations.removeValue(forKey: id)
                     continue
                 }

                 DispatchQueue.main.async(execute: {
                     observer.statusDidChange(status: path.status)
                 })
             }
         }
         monitor.start(queue: DispatchQueue.global(qos: .background))
     }

     func addObserver(observer: NetworkCheckProtocol) {
         let id = ObjectIdentifier(observer)
         observations[id] = NetworkChangeObservation(observer: observer)
     }

     func removeObserver(observer: NetworkCheckProtocol) {
         let id = ObjectIdentifier(observer)
         observations.removeValue(forKey: id)
     }
}
