//
//  PersonalViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/31.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var smallPortraitButton: UIButton!
    @IBOutlet weak var largePortraitImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.sendSubviewToBack((self.navigationController?.navigationBar)!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func projectsButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
    }
    
}
