//
//  LoginViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import BWWalkthrough

class LoginViewController: BWWalkthroughPageViewController {

    @IBOutlet weak var emailTextFieldView: APTextFieldView!
    @IBOutlet weak var passwordTextFieldView: APTextFieldView!
    @IBOutlet weak var confirmPasswordTextFieldView: APTextFieldView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var textFieldPlacingConstraint_1: NSLayoutConstraint!
    @IBOutlet weak var textFieldPlacingConstraint_2: NSLayoutConstraint!
    @IBOutlet weak var textFieldPlacingConstraint_3: NSLayoutConstraint!
    
    var isSignUpStatus: Bool = true {
        didSet {
            confirmPasswordTextFieldView.isHidden = !isSignUpStatus
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(
            keyboardPositionWillChange(notification:)), name: UIResponder
                .keyboardWillChangeFrameNotification, object: nil)
        emailTextFieldView.textField.placeholder = "Email Address"
        passwordTextFieldView.textField.placeholder = "Password"
        confirmPasswordTextFieldView.textField.placeholder = "Confirm Password"
        emailTextFieldView.textField.keyboardType = .emailAddress
        passwordTextFieldView.textField.keyboardType = .asciiCapable
        passwordTextFieldView.textField.isSecureTextEntry = true
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        signUpButton.setTitleColor(APTheme.darkGreyColor, for: .normal)
        loginButton.setTitleColor(UIColor.lightGray, for: .normal)
        isSignUpStatus = true
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        signUpButton.setTitleColor(UIColor.lightGray, for: .normal)
        loginButton.setTitleColor(APTheme.darkGreyColor, for: .normal)
        isSignUpStatus = false
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
                    let multiplierConstant: CGFloat = self.isSignUpStatus ? 0.3 : 0.35
                    self.textFieldPlacingConstraint_1 = self.textFieldPlacingConstraint_1
                        .setMultiplier(multiplier: multiplierConstant)
                    self.textFieldPlacingConstraint_2 = self.textFieldPlacingConstraint_2
                        .setMultiplier(multiplier: multiplierConstant)
                    if self.isSignUpStatus {
                        self.textFieldPlacingConstraint_3.constant = 24
                    }
                } else {
                    self.textFieldPlacingConstraint_1 = self.textFieldPlacingConstraint_1
                        .setMultiplier(multiplier: 0.55)
                    self.textFieldPlacingConstraint_2 = self.textFieldPlacingConstraint_2
                        .setMultiplier(multiplier: 0.55)
                    self.textFieldPlacingConstraint_3.constant = 48
                }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

}



