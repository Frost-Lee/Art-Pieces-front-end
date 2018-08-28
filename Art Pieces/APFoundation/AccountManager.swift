//
//  AccountManager.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/28.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation

class AccountManager {
    
    init() {
//        if let currentUserEmail = UserDefaults.standard.string(forKey: "currentUserEmail") {
//            currentUser = 
//        }
    }
    
    static let sharedInstance = AccountManager()
    
    var currentUser: User?
    
}
