//
//  AddArtworkView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol AddArtworkDelegate: class {
    func importButtonDidTapped(_ sender: UIButton)
    func createButtonDidTapped(_ sender: UIButton)
}

class AddArtworkView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var topConstraint_1: NSLayoutConstraint! {
        didSet {
            resetTopConstraints()
        }
    }
    @IBOutlet weak var topConstraint_2: NSLayoutConstraint! {
        didSet {
            resetTopConstraints()
        }
    }
    
    weak var delegate: AddArtworkDelegate?
    
    var useNavigationBarIncludedLayout: Bool = false {
        didSet {
            resetTopConstraints()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deactivate(animated: false)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.deactivate()
    }
    
    @IBAction func importButtonTapped(_ sender: UIButton) {
        delegate?.importButtonDidTapped(sender)
    }
    
    @IBAction func createButtonTapped(_ sender: UIButton) {
        delegate?.createButtonDidTapped(sender)
    }
    
    @objc func handleTapGestureRecognizer() {
        deactivate()
    }
    
    func activate(animated: Bool = true) {
        cancelButton.isEnabled = true
        importButton.isEnabled = true
        createButton.isEnabled = true
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
            }
        } else {
            self.alpha = 1
        }
    }
    
    func deactivate(animated: Bool = true) {
        cancelButton.isEnabled = false
        importButton.isEnabled = false
        createButton.isEnabled = false
        if animated {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 0
            }
        } else {
            self.alpha = 0
        }
    }
    
    private func resetTopConstraints() {
        if topConstraint_1 != nil && topConstraint_2 != nil {
            if useNavigationBarIncludedLayout {
                topConstraint_1.constant = 50
                topConstraint_2.constant = 137
                layoutIfNeeded()
            }
        }
    }
    
}
