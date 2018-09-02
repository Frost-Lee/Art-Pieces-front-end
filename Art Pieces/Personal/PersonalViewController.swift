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
    @IBOutlet weak var personalCollectionView: UICollectionView! {
        didSet {
            personalCollectionView.register(UINib(nibName: "GalleryCollectionViewCell",
                bundle: Bundle.main), forCellWithReuseIdentifier: "personalCollectionViewCell")
        }
    }
    @IBOutlet weak var userBackgroundImageView: UIImageView! {
        didSet {
            userBackgroundImageView.clipsToBounds = true
        }
    }
    
    var addArtworkView: AddArtworkView!
    
    private var projects: [ProjectPreview] = []
    private var localUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.sendSubviewToBack((self.navigationController?.navigationBar)!)
        self.navigationController?.navigationBar.tintColor = .white
        setupAddArtworkView()
        loadLocalUser()
        loadProjects()
        personalCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
    }

    @IBAction func addButtonTapped(_ sender: UIButton) {
        addArtworkView.activate()
    }
    
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func settingButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func projectsButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
    }
    
    private func setupAddArtworkView() {
        let nib = UINib(nibName: "AddArtworkView", bundle: Bundle.main)
        addArtworkView = nib.instantiate(withOwner: self, options: nil).first as? AddArtworkView
        self.view.addSubview(addArtworkView)
    }
    
    private func loadLocalUser() {
        localUser = AccountManager.defaultManager.currentUser!
        userNameLabel.text = localUser.name
    }
    
    private func loadProjects() {
        let lectures = DataManager.defaultManager.getAllLectures()
        // let creatorPortrait = DataManager.defaultManager.getImage(path: localUser.portraitPath!)
        for lecture in lectures {
            let lectureKeyPhoto = DataManager.defaultManager.getImage(path: lecture.previewPhotoPath!)
            let project = ProjectPreview(keyPhoto: lectureKeyPhoto, title: lecture.title!,
                                  creatorName: localUser.name, creatorPortrait: nil,
                                  numberOfForks: 0, numberOfStars: 0)
            projects.append(project)
        }
    }
    
}


extension PersonalViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "personalCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.project = projects[indexPath.row]
        cell.index = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20 * 2 - 36 * 2) / 3
        let height = width / 0.967
        return CGSize(width: width, height: height)
    }
}
