//
//  LecturePublishView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol LecturePublishDelegate: class {
    func shareButtonDidTapped()
}

class LecturePublishView: UIView {

    @IBOutlet weak var lectureTitleTextField: UITextField!
    @IBOutlet weak var lectureDescriptionTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var lectureKeyphotoImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let webService = APWebService.defaultManager
    let dataManager = DataManager.defaultManager
    
    weak var delegate: LecturePublishDelegate?
    
    var artboard: MyArtboard! {
        didSet {
            if lectureKeyphotoImageView != nil {
                lectureKeyphotoImageView.image = dataManager.getImage(path: artboard.keyPhotoPath!)
            }
        }
    }
    
    var title: String {
        return lectureTitleTextField.text!
    }
    
    var lectureDescription: String {
        return lectureDescriptionTextView.text
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        startAnimating()
        delegate?.shareButtonDidTapped()
    }
    
    @IBAction func titleTextFieldChanged(_ sender: UITextField) {
        shareButton.isEnabled = !lectureTitleTextField.text!.isEmpty
    }
    
    private func startAnimating() {
        shareButton.isHidden = true
        spinner.startAnimating()
    }
    
}


extension LecturePublishView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
