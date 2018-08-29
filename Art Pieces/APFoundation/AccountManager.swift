//
//  AccountManager.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/28.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

struct User {
    var name: String
    var email: String
    var portraitPath: String
    var password: String
}


class AccountManager {
    
    static let defaultManager = AccountManager()
    
    var currentUser: User? = nil
    
    init() {
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            let userName = UserDefaults.standard.string(forKey: "name")
            let userPortraitPath = UserDefaults.standard.string(forKey: "portrait")
            let userPassword = UserDefaults.standard.string(forKey: "password")
            self.currentUser = User(name: userName!, email: userEmail, portraitPath:
                userPortraitPath!, password: userPassword!)
        }
    }
    
    func login(email: String, name: String, portrait: UIImage, password: String) {
        DataManager.defaultManager.removeItem(path: currentUser?.portraitPath)
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(DataManager.defaultManager
            .savePhoto(photo: portrait, isCachedPhoto: false), forKey: "portrait")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
}
