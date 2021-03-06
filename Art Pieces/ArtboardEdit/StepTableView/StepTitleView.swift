//
//  StepTitleView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/21.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol StepTitleDelegate: class {
    func stepTitleBarDidTapped()
}

class StepTitleView: UIView {

    @IBOutlet weak var stepNameLabel: UILabel!
    @IBOutlet weak var detailArrowImageView: UIImageView!
    
    static var height: CGFloat = 35
    
    weak var delegate: StepTitleDelegate?
    
    var stepName: String! {
        didSet {
            if stepNameLabel != nil {
                stepNameLabel.text = stepName
            }
        }
    }
    
    @IBAction func stepTitleTapped(_ sender: UIButton) {
        delegate?.stepTitleBarDidTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepNameLabel.text = stepName
    }
    
}
