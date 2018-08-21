//
//  ArtworkLayerView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/13.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtworkLayerView: UIView {
    
    var artworkLayer: Layer!
    var eraseBufferStroke: Stroke?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        artworkLayer = Layer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        artworkLayer = Layer()
    }
    
    override func draw(_ rect: CGRect) {
        for stroke in artworkLayer.strokes {
            render(stroke: stroke)
        }
        render(stroke: eraseBufferStroke)
    }
    
    func mergeEraseStroke() {
        if let eraseStroke = eraseBufferStroke {
            artworkLayer.add(stroke: eraseStroke)
            eraseBufferStroke = nil
        }
    }
    
}
