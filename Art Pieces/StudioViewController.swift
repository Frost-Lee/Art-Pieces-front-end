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
        self.view.addSubview(artworkView)
        artworkView.currentRenderMechanism = RenderMechanism(color: .blue, width: 3, texture: "CrayonTexture")
        artworkView.switchLayer(to: 0)
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
