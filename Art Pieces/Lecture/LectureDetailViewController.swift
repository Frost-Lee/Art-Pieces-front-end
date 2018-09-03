//
//  LectureDetailViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/10.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LectureDetailViewController: UIViewController {

    @IBOutlet weak var stepBackgroundView: UIView!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
        stepBackgroundView.layer.borderWidth = 1.0
        stepBackgroundView.layer.borderColor = APTheme.separatorColor.cgColor
        downloadButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}
