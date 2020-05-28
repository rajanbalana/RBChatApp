//
//  Datastore.swift
//  RBChatApp
//
//  Created by Rajan Balana on 27/05/20.
//  Copyright © 2020 Rajan Balana. All rights reserved.
//

import Foundation

protocol Datastore {
    func getLoggedInUserId() -> String?
    func saveLoggedInUserId(_ id: String)
}

struct LocalDataStorage: Datastore {

    let loggedInUserIdKey = "loggedInUserId"
    
    func getLoggedInUserId() -> String? {
        let userDefaults = UserDefaults.standard
        return userDefaults.value(forKey: loggedInUserIdKey) as? String
    }
    
    func saveLoggedInUserId(_ id: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(id, forKey: loggedInUserIdKey)
        userDefaults.synchronize()
    }
}
