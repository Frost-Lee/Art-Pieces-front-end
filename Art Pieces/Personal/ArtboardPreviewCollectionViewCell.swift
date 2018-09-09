//
//  ArtboardPreviewCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol ArtboardPreviewDelegate: class {
    func artboardNameDidChanged(at index: Int, to name: String)
    func artboardNameBeginEditting(at index: Int)
}

class ArtboardPreviewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var keyImageView: UIImageView! {
        didSet {
            keyImageView.layer.shadowColor = UIColor.lightGray.cgColor
            keyImageView.layer.shadowOpacity = 0.3
            keyImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    @IBOutlet weak var artboardNameTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    weak var delegate: ArtboardPreviewDelegate?
    
    var keyPhoto: UIImage? {
        get {
            return keyImageView.image
        } set {
            keyImageView.image = newValue
        }
    }
    
    var index: Int!
    
    @IBAction func artboardNameEditted(_ sender: UITextField) {
        delegate?.artboardNameDidChanged(at: index, to: sender.text!)
    }
    
    @IBAction func artboardNameBeginEditting(_ sender: UITextField) {
        delegate?.artboardNameBeginEditting(at: index)
    }
}
