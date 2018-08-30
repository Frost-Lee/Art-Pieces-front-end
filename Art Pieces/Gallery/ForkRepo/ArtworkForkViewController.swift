//
//  ArtworkForkViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtworkForkViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    
    var pickArtworkView: PickArtworkView!
    var addArtworkDescriptionView: AddArtworkDescriptionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickArtworkView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let viewFrame = self.view.frame
        pickArtworkView.frame = CGRect(x: 0, y: 20, width: viewFrame.width, height: viewFrame.height - 20)
    }

    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupPickArtworkView() {
        let nib = UINib(nibName: "PickArtworkView", bundle: Bundle.main)
        pickArtworkView = nib.instantiate(withOwner: self, options: nil).first as? PickArtworkView
        self.view.insertSubview(pickArtworkView, belowSubview: closeButton)
    }
    
}
