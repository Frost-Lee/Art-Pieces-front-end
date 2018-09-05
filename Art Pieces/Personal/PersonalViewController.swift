//
//  PersonalViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/31.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {
    
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
    private var localUser: User?
    
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
    
    @IBAction func modifyUserButtonTapped(_ sender: UIButton) {
        if localUser == nil {
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let viewController = storyboard.instantiateInitialViewController() as! LoginViewController
            viewController.dismissBlock = {self.loadLocalUser()}
            present(viewController, animated: true)
        }
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
        addArtworkView.useNavigationBarIncludedLayout = true
        self.view.addSubview(addArtworkView)
    }
    
    private func loadLocalUser() {
        let portrait = getPersonalPortrait()
        if AccountManager.defaultManager.isUserExist() {
            localUser = AccountManager.defaultManager.currentUser
            userNameLabel.text = localUser!.name
            largePortraitImageView.image = portrait
        } else {
            userNameLabel.text = "Login / Register"
            largePortraitImageView.image = portrait
        }
    }
    
    private func loadProjects() {
        let lectures = DataManager.defaultManager.getAllLectures()
        let creatorPortrait = getPersonalPortrait()
        for lecture in lectures {
            let lectureKeyPhoto = DataManager.defaultManager.getImage(path: lecture.previewPhotoPath!)
            let project = ProjectPreview(keyPhoto: lectureKeyPhoto, title: lecture.title!,
                                  creatorName: localUser?.name ?? "Login", creatorPortrait: creatorPortrait,
                                  numberOfForks: 0, numberOfStars: 0)
            projects.append(project)
        }
    }
    
    private func getPersonalPortrait() -> UIImage {
        var portrait: UIImage!
        if localUser == nil {
            portrait = UIImage(named: "WhiteQuestionMark")
        } else if localUser!.portraitPath != nil && localUser!.portraitPath?.count != 0 {
            portrait = DataManager.defaultManager.getImage(path: localUser!.portraitPath!)
        } else {
            portrait = UIImage(named: "WhiteUser")
        }
        return portrait
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
