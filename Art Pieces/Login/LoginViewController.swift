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
    @IBOutlet weak var beginLoginButton: UIButton!
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollAnimationContainerView: UIView!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.isHidden = !showCancelButton
        }
    }
    
    var albumImageView: UIImageView? = nil
    var positiveScroll: Bool = true
    var isSignUpStatus: Bool = true {
        didSet {
            confirmPasswordTextFieldView.isHidden = !isSignUpStatus
        }
    }
    var showCancelButton: Bool = true {
        didSet {
            if cancelButton != nil {
                cancelButton.isHidden = !showCancelButton
            }
        }
    }
    
    private var isKeyboardOpen: Bool = false
    
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
        confirmPasswordTextFieldView.textField.isSecureTextEntry = true
        emailTextFieldView.delegate = self
        passwordTextFieldView.delegate = self
        confirmPasswordTextFieldView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginAnimateAlbums()
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if !isSignUpStatus {
            clearTextFields()
            signUpButton.setTitleColor(APTheme.darkGreyColor, for: .normal)
            loginButton.setTitleColor(UIColor.lightGray, for: .normal)
            isSignUpStatus = true
        }
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if isSignUpStatus {
            clearTextFields()
            signUpButton.setTitleColor(UIColor.lightGray, for: .normal)
            loginButton.setTitleColor(APTheme.darkGreyColor, for: .normal)
            isSignUpStatus = false
        }
    }
    
    @IBAction func beginLoginProcedure(_ sender: UIButton) {
        beginLoginButton.isHidden = true
        loginSpinner.startAnimating()
        if isSignUpStatus {
            beginSigningUp()
        } else {
            beginLogingin()
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController.prepareController(title: "Don't panic!",
            message: "Contact us at feetback@artpieces.cn")
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardPositionWillChange(notification: Notification) {
        if let userInfo = notification.userInfo,
            let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            let intersect = frame.intersects(passwordTextFieldView.frame)
            UIView.animate(withDuration: duration, delay: 0.0, options:
                UIView.AnimationOptions(rawValue: curve), animations: {
                if intersect {
                    self.textFieldPlacingConstraint_1 = self.textFieldPlacingConstraint_1
                        .setMultiplier(multiplier: 0.33)
                    self.textFieldPlacingConstraint_2 = self.textFieldPlacingConstraint_2
                        .setMultiplier(multiplier: 0.33)
                    self.textFieldPlacingConstraint_3.constant = 24
                } else if duration > 0.005 {
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
    
    private func beginLogingin() {
        let email = emailTextFieldView.text
        let password = passwordTextFieldView.text
        APWebService.defaultManager.checkForLogin(email: email,
            password: password) { errorMessage in
            if let message = errorMessage {
                let alertController = UIAlertController.prepareController(title: "Oooooops!", message: message)
                self.present(alertController, animated: true) {
                    self.stopRequesting()
                }
            } else {
                AccountManager.defaultManager.login(email: email, password: password) {
                    // Refresh Home Page Code Here
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func beginSigningUp() {
        if passwordTextFieldView.text == confirmPasswordTextFieldView.text
            && passwordTextFieldView.text != "" {
            APWebService.defaultManager.registerUser(email: emailTextFieldView.text,
                password: passwordTextFieldView.text) { errorMessage in
                if let message = errorMessage {
                    let alertController = UIAlertController.prepareController(title: "Oooooops!", message: message)
                    self.present(alertController, animated: true) {
                        self.stopRequesting()
                    }
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            let alertController = UIAlertController.prepareController(title: "Oooooops!",
                message: "The passwords you entered is not the same.")
            self.present(alertController, animated: true) {
                self.stopRequesting()
            }
        }
    }
    
    private func clearTextFields() {
        emailTextFieldView.clear()
        passwordTextFieldView.clear()
        confirmPasswordTextFieldView.clear()
    }
    
    private func stopRequesting() {
        self.beginLoginButton.isHidden = false
        self.loginSpinner.stopAnimating()
    }
    
    private func beginAnimateAlbums(_ whatHell: Bool = true) {
        if albumImageView == nil {
            let albumImage = UIImage(named: "ScrollAnimationBackground")!
            albumImageView = UIImageView(image: albumImage)
            albumImageView!.contentMode = .scaleAspectFill
            scrollAnimationContainerView.addSubview(albumImageView!)
            let scaleConstant = scrollAnimationContainerView.frame.width / albumImageView!.frame.width
            albumImageView!.frame = CGRect(x: 0, y: 0, width: scrollAnimationContainerView.frame.width,
                                           height: albumImageView!.frame.height * scaleConstant)
        }
        let deltaHeight = albumImageView!.frame.height - scrollAnimationContainerView.frame.height
        UIView.animate(withDuration: 50, delay: 0, options:
            UIView.AnimationOptions.curveLinear, animations: {
                let yAxisHeight = self.positiveScroll ? -deltaHeight : 0
                self.albumImageView!.frame = CGRect(x: 0, y: yAxisHeight,
                                                    width: self.scrollAnimationContainerView.frame.width,
                                                    height: self.albumImageView!.frame.height)
                self.positiveScroll = !self.positiveScroll
        }, completion: beginAnimateAlbums)
    }

}


extension LoginViewController: APTextFieldDelegate {
    func textFieldDidChangedEditing() {
        if !emailTextFieldView.isEmpty && !passwordTextFieldView.isEmpty {
            if isSignUpStatus && confirmPasswordTextFieldView.isEmpty {
                beginLoginButton.isEnabled = false
            } else {
                beginLoginButton.isEnabled = true
            }
        } else {
            beginLoginButton.isEnabled = false
        }
    }
}
