//
//  SubStepView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/21.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol SubStepViewDelegate {
    func subStepInteractionButtonDidTapped()
}

class SubStepView: UIView {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    @IBOutlet weak var interactionButton: UIButton!
    
    var delegate: SubStepViewDelegate!
    var index: Int!
    
    var operationDescription: String! {
        didSet {
            if descriptionLabel != nil {
                descriptionLabel.text = operationDescription
            }
        }
    }
    
    var operationSubDescription: String? {
        didSet {
            if subDescriptionLabel != nil {
                subDescriptionLabel.text = operationSubDescription
            }
        }
    }
    
    var isToolInteractive: Bool! {
        didSet {
            if interactionButton != nil {
                interactionButton.isEnabled = isToolInteractive
            }
        }
    }
    
//    init(frame: CGRect, description: String, isInteractive: Bool, subDiscription: String? = nil) {
//        operationDescription = description
//        isToolInteractive = isInteractive
//        operationSubDescription = subDiscription
//        super.init(frame: frame)
//    }
    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        descriptionLabel.text = operationDescription
        subDescriptionLabel.text = operationSubDescription
        interactionButton.isEnabled = isToolInteractive
    }
    
    @IBAction func interactiveButtonTapped(_ sender: UIButton) {
        delegate.subStepInteractionButtonDidTapped()
    }
    
}
