//
//  PersonalViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/31.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
    struct Project {
        var keyPhoto: UIImage
        var title: String
        var creatorName: String
        var creatorPortrait: UIImage
        var numberOfForks: Int
        var numberOfStars: Int
    }
    
    @IBOutlet weak var smallPortraitButton: UIButton!
    @IBOutlet weak var largePortraitImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var personalCollectionView: UICollectionView! {
        didSet {
            personalCollectionView.register(UINib(nibName: "GalleryCollectionViewCell",
                bundle: Bundle.main), forCellWithReuseIdentifier: "personalCollectionViewCell")
        }
    }
    
    private var projects: [Project] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.sendSubviewToBack((self.navigationController?.navigationBar)!)
        let lectures = DataManager.defaultManager.getAllLectures()
        let localUser = AccountManager.defaultManager.currentUser!
        let creatorPortrait = DataManager.defaultManager.getImage(path: localUser.portraitPath!)
        for lecture in lectures {
            let lectureKeyPhoto = DataManager.defaultManager.getImage(path: lecture.previewPhotoPath!)
            let project = Project(keyPhoto: lectureKeyPhoto, title: lecture.title!,
                                  creatorName: localUser.name, creatorPortrait: creatorPortrait,
                                  numberOfForks: 0, numberOfStars: 0)
            projects.append(project)
        }
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


extension PersonalViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "personalCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20 * 2 - 36 * 2) / 3
        let height = width / 0.967
        return CGSize(width: width, height: height)
    }
}
