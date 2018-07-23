//
//  LectureViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/22.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class LectureViewController: UIViewController {

    @IBOutlet weak var masterNavigationView: MasterNavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MasterNavigationView", bundle: nil)
        self.edgesForExtendedLayout = []
        masterNavigationView = nib.instantiate(withOwner: self, options: nil).first as? MasterNavigationView
        masterNavigationView.frame = CGRect(x: 0, y: 0, width: 1024, height: 110)
        self.view.addSubview(masterNavigationView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func pushButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showLecturePresentationViewController", sender: nil)
    }

}
