//
//  BranchCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/14.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol BranchCollectionViewDelegate: class {
    func branchDetailShouldShow(index: Int)
}

class BranchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var branchKeyPhoto: UIImageView! {
        didSet {
            branchKeyPhoto.clipsToBounds = true
            branchKeyPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDetected)))
        }
    }
    
    weak var delegate: BranchCollectionViewDelegate?
    
    var index: Int = 0
    
    @objc private func tapDetected() {
        delegate?.branchDetailShouldShow(index: index)
    }
}
