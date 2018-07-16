//
//  StudioViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/16.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class StudioViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var artworkView: ArtworkView!
    var fingerStrokeRecognizer: StrokeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        artworkView = ArtworkView(frame: self.view.frame)
        fingerStrokeRecognizer = StrokeGestureRecognizer(target: self, action: #selector(strokeUpdated(_:)))
        fingerStrokeRecognizer.delegate = self
        fingerStrokeRecognizer.cancelsTouchesInView = true
        artworkView.addGestureRecognizer(fingerStrokeRecognizer)
        fingerStrokeRecognizer.coordinateSpaceView = artworkView
        self.view.addSubview(artworkView)
        
        artworkView.addLayer()
    }
    
    @objc func strokeUpdated(_ strokeGesture: StrokeGestureRecognizer) {
        var stroke: Stroke?
        if strokeGesture.state != .cancelled {
            stroke = strokeGesture.stroke
        }
        if let updatedStroke = stroke {
            if strokeGesture.state == .ended {
                artworkView.activeStrokeView.stroke = updatedStroke
                artworkView.mergeActiveStroke()
            } else {
                artworkView.activeStrokeView.stroke = updatedStroke
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
