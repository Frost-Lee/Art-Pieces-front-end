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
    var signature: String
    var portraitPath: String?
}

class AccountManager {
    
    static let defaultManager = AccountManager()
    
    var currentUser: User? = nil
    
    init() {
        updateCurrentUser()
    }
    
    func isUserExist() -> Bool {
        return currentUser == nil ? false : true
    }
    
    func login(email: String, password: String, isFirstLogin: Bool = false, completion: ((() -> ())?)) {
        if !isFirstLogin {
            APWebService.defaultManager.getUserInfo(email: email) { name, signature, portrait in
                if let name = name {
                    self.login(email: email, name: name, password: password, signature: signature,
                               portrait: portrait)
                }
                completion?()
            }
        } else {
            login(email: email, name: email, password: password, signature: "", portrait: nil)
            completion?()
        }
    }
    
    private func login(email: String, name: String, password: String,
                       signature: String, portrait: UIImage?) {
        DataManager.defaultManager.removeItem(path: currentUser?.portraitPath)
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.set(signature, forKey: "signature")
        if let portrait = portrait {
            UserDefaults.standard.set(DataManager.defaultManager
                .saveImage(photo: portrait, isCachedPhoto: false), forKey: "portrait")
        }
        updateCurrentUser()
    }
    
    private func updateCurrentUser() {
        if let userEmail = UserDefaults.standard.string(forKey: "email") {
            let userName = UserDefaults.standard.string(forKey: "name")
            let userPortraitPath = UserDefaults.standard.string(forKey: "portrait")
            let userPassword = UserDefaults.standard.string(forKey: "password")
            let signature = UserDefaults.standard.string(forKey: "signature")
            currentUser = User(name: userName!, email: userEmail, password: userPassword!,
                               signature: signature!, portraitPath: userPortraitPath)
        }
    }
}
