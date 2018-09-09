//
//  LecturePublishViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LecturePublishViewController: APFormSheetViewController {
    
    var lecturePublishView: LecturePublishView!
    
    var artboard: MyArtboard!
    
    let webService = APWebService.defaultManager

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLecturePublishView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        lecturePublishView.frame = CGRect(x: 0, y: 20, width: self.view.frame.width,
                                   height: self.view.frame.height - 20)
    }
    
    private func setupLecturePublishView() {
        let nib = UINib(nibName: "LecturePublish", bundle: Bundle.main)
        lecturePublishView = nib.instantiate(withOwner: self, options: nil).first as? LecturePublishView
        self.view.insertSubview(lecturePublishView, belowSubview: closeButton)
        lecturePublishView.artboard = artboard
        lecturePublishView.delegate = self
    }

}


extension LecturePublishViewController: LecturePublishDelegate {
    func shareButtonDidTapped() {
        let user = AccountManager.defaultManager.currentUser!
        webService.uploadLecture(creatorEmail: user.email, creatorPassword: user.password, title:
        lecturePublishView.title, description: lecturePublishView.lectureDescription, content:
        artboard.content!, selfID: artboard.uuid!) {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
