//
//  AddArtworkDescriptionView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol AddArtworkDescriptionDelegate: class {
    func shareButtonTapped()
}

class AddArtworkDescriptionView: UIView {

    @IBOutlet weak var artworkKeyPhotoImageView: UIImageView!
    @IBOutlet weak var artworkDescriptionTextField: UITextView! {
        didSet {
            artworkDescriptionTextField.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var delegate: AddArtworkDescriptionDelegate?
    
    var artworkDescription: String {
        return artworkDescriptionTextField.text
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        delegate?.shareButtonTapped()
    }
    
    func startAnimating() {
        shareButton.isHidden = true
        spinner.startAnimating()
    }
    
}


extension AddArtworkDescriptionView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
}
