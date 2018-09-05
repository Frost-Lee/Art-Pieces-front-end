//
//  NewRepoView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/4.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol NewRepoDelegate: class {
    func shareButtonDidTapped()
}

class NewRepoView: UIView {
    
    @IBOutlet weak var repoTitleTextField: UITextField! {
        didSet {
            repoTitleTextField.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var repoDescriptionTextView: UITextView! {
        didSet {
            repoDescriptionTextView.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var keyPhotoImageView: UIImageView! {
        didSet {
            keyPhotoImageView.image = keyPhoto
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var delegate: NewRepoDelegate?
    
    var keyPhoto: UIImage? {
        didSet {
            if keyPhotoImageView != nil {
                keyPhotoImageView.image = keyPhoto
            }
        }
    }
    
    var title: String {
        return repoTitleTextField.text ?? ""
    }
    
    var repoDescription: String {
        return repoDescriptionTextView.text ?? ""
    }
    
    @IBAction func titleDidChanged(_ sender: UITextField) {
        shareButton.isEnabled = (title.count != 0)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonDidTapped()
    }
    
    func beginAnimatingSpinner() {
        shareButton.isHidden = true
        spinner.startAnimating()
    }
    
}


extension NewRepoView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = (textView.text.count != 0)
    }
}
