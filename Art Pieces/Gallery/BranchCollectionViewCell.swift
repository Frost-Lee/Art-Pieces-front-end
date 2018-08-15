//
//  BranchCollectionViewCell.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/14.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class BranchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var branchKeyPhoto: UIImageView! {
        didSet {
            branchKeyPhoto.clipsToBounds = true
        }
    }
}
