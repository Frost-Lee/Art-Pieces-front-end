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
    var password: String
    var portraitPath: String?
    var compressedPortraitPath: String?
}


class AccountManager {
    
    static let defaultManager = AccountManager()
    
    var currentUser: User? = nil
    
    init() {
        updateCurrentUser()
    }
    
    func isUserExist() -> Bool {
        if let _ = UserDefaults.standard.string(forKey: "email") {
            return true
        } else {
            return false
        }
    }
    
    func login(email: String, password: String, completion: ((() -> ())?)) {
        APWebService.defaultManager.getUserInfo(email: email) { name, portrait, compressedPortrait in
            self.login(email: email, name: name, password: password,
                       portrait: portrait, compressedPortrait: compressedPortrait)
            self.updateCurrentUser()
            completion?()
        }
    }
    
    private func updateCurrentUser() {
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            let userName = UserDefaults.standard.string(forKey: "name")
            let userPortraitPath = UserDefaults.standard.string(forKey: "portrait")
            let userPassword = UserDefaults.standard.string(forKey: "password")
            let userCompressedPortraitPath = UserDefaults.standard.string(forKey: "compressedPortrait")
            currentUser = User(name: userName!, email: userEmail, password: userPassword!,
                               portraitPath: userPortraitPath, compressedPortraitPath: userCompressedPortraitPath)
        }
    }
    
    private func login(email: String, name: String, password: String, portrait: UIImage?, compressedPortrait: UIImage?) {
        DataManager.defaultManager.removeItem(path: currentUser?.portraitPath)
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(password, forKey: "password")
        if let portrait = portrait {
            UserDefaults.standard.set(DataManager.defaultManager
                .saveImage(photo: portrait, isCachedPhoto: false), forKey: "portrait")
        }
        if let compressedPortrait = compressedPortrait {
            UserDefaults.standard.set(DataManager.defaultManager
                .saveImage(photo: compressedPortrait, isCachedPhoto: false), forKey: "compressedPortrait")
        }
    }
    
}
