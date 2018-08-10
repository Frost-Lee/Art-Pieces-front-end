//
//  LoginViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textFieldPlacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(
            keyboardPositionWillChange(notification:)), name: UIResponder
                .keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardPositionWillChange(notification: Notification) {
        
    }

}
