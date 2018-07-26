//
//  ToolBarView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/23.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import ChromaColorPicker

protocol ToolBarViewDelegate {
    
    func palletButtonDidTapped(_ sender: UIButton)
    func layerButtonDidTapped(_ sender: UIButton)
    func thichnessButtonDidTapped(_ sender: UIButton)
    func transparencyButtonDidTapped(_ sender: UIButton)
    func eraserButtonDidTapped(_ sender: UIButton)
    func penButtonDidTapped(_ sender: UIButton)
    
}

class ToolBarView: UIView {
    
    private var contentView: UIView!
    
    @IBOutlet weak var penButton: UIButton!
    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var transparencyButton: UIButton!
    @IBOutlet weak var thicknessButton: UIButton!
    @IBOutlet weak var layerButton: UIButton!
    @IBOutlet weak var palletButton: UIButton! {
        didSet {
            if oldValue == nil {
                palletButton.layer.cornerRadius = palletButton.frame.width / 2
                palletButton.clipsToBounds = true
            }
        }
    }
    
    var delegate: ToolBarViewDelegate?
    
    @IBAction func palletButtonTapped(_ sender: UIButton) {
        delegate?.palletButtonDidTapped(sender)
    }
    
    @IBAction func layerButtonTapped(_ sender: UIButton) {
        delegate?.layerButtonDidTapped(sender)
    }
    
    @IBAction func thicknessButtonTapped(_ sender: UIButton) {
        delegate?.thichnessButtonDidTapped(sender)
    }
    
    @IBAction func transparencyButtonTapped(_ sender: UIButton) {
        delegate?.transparencyButtonDidTapped(sender)
    }
    
    @IBAction func eraserButtonTapped(_ sender: UIButton) {
        delegate?.eraserButtonDidTapped(sender)
    }
    
    @IBAction func penButtonTapped(_ sender: UIButton) {
        delegate?.penButtonDidTapped(sender)
    }
}
