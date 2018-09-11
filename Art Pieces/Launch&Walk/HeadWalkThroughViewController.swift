//
//  HeadWalkThroughViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/29.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import BWWalkthrough

class HeadWalkThroughViewController: BWWalkthroughPageViewController {

    @IBOutlet weak var scrollAnimationContainerView: UIView!
    var albumImageView: UIImageView? = nil
    
    var positiveScroll: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beginAnimateAlbums()
    }
    
    private func beginAnimateAlbums(_ whatHell: Bool = true) {
        if albumImageView == nil {
            let albumImage = UIImage(named: "ScrollAnimationBackground")!
            albumImageView = UIImageView(image: albumImage)
            albumImageView!.contentMode = .scaleAspectFill
            scrollAnimationContainerView.addSubview(albumImageView!)
            let scaleConstant = scrollAnimationContainerView.frame.width / albumImageView!.frame.width
            albumImageView!.frame = CGRect(x: 0, y: 0, width: scrollAnimationContainerView.frame.width,
                                          height: albumImageView!.frame.height * scaleConstant)
        }
        let deltaHeight = albumImageView!.frame.height - scrollAnimationContainerView.frame.height
        UIView.animate(withDuration: 50, delay: 0, options:
            UIViewAnimationOptions.curveLinear, animations: {
                let yAxisHeight = self.positiveScroll ? -deltaHeight : 0
                self.albumImageView!.frame = CGRect(x: 0, y: yAxisHeight, width: self.scrollAnimationContainerView.frame.width,
                                                   height: self.albumImageView!.frame.height)
                self.positiveScroll = !self.positiveScroll
        }, completion: beginAnimateAlbums)
    }

}
