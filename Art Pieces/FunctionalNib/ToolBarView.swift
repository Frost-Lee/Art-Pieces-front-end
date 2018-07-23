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
    func colorDidPicked(color: UIColor)
}

class ToolBarView: UIView {
    
    @IBOutlet weak var palletButton: UIButton! {
        didSet {
            if oldValue == nil {
                palletButton.layer.cornerRadius = palletButton.frame.width / 2
                palletButton.clipsToBounds = true
            }
        }
    }
    
    var delegate: ToolBarViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func palletButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func layerButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func thicknessButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func transparencyButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func eraserButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func penButtonTapped(_ sender: UIButton) {
    }
    
}

extension ToolBarView: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        delegate?.colorDidPicked(color: color)
    }
    
}
