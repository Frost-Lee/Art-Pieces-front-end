//
//  ArtworkView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/15.
//  Copyright © 2018 李灿晨. All rights reserved.
//
//  Abstract:
//  The ArtworkView is the view that is used for the user to draw on, StrokeGestureRecognizer is used so that
//  user's interaction with the screen would be recorded.


import UIKit

class ArtworkView: UIView {
    
    var activeStrokeView: SingleStrokeView!
    var strokeGestureRecognizer: StrokeGestureRecognizer!
    var layers: [Layer] = []
    var currentLayer: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.drawsAsynchronously = true
        activeStrokeView = SingleStrokeView(frame: frame)
        self.addSubview(activeStrokeView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rerender() {
        for layer in layers {
            for stroke in layer.strokes {
                render(stroke: stroke)
            }
        }
    }
    
    func mergeActiveStroke() {
        if let newStroke = activeStrokeView.stroke {
            layers[currentLayer].add(stroke: newStroke)
        }
        activeStrokeView.stroke = nil
        setNeedsDisplay()
    }
    
    @discardableResult
    func addLayer() -> Int {
        layers.append(Layer())
        currentLayer = layers.count - 1
        return layers.count - 1
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.set()
        UIRectFill(rect)
        
        rerender()
    }

}
