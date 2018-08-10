//
//  LoginViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFieldView: APTextFieldView!
    @IBOutlet weak var passwordTextFieldView: APTextFieldView!
    @IBOutlet weak var textFieldPlacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(
            keyboardPositionWillChange(notification:)), name: UIResponder
                .keyboardWillChangeFrameNotification, object: nil)
        emailTextFieldView.textField.placeholder = "Email Address"
        passwordTextFieldView.textField.placeholder = "Password"
        emailTextFieldView.textField.keyboardType = .emailAddress
        passwordTextFieldView.textField.keyboardType = .asciiCapable
        passwordTextFieldView.textField.isSecureTextEntry = true
    }
    
    @objc func keyboardPositionWillChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersect = frame.intersects(passwordTextFieldView.frame)
            UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions(rawValue: curve), animations: {
                if intersect {
                    self.textFieldPlacingConstraint = self.textFieldPlacingConstraint
                        .setMultiplier(multiplier: 0.6)
                } else {
                    self.textFieldPlacingConstraint = self.textFieldPlacingConstraint
                        .setMultiplier(multiplier: 0.8)
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}



