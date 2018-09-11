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
    @IBOutlet weak var personalCollectionView: UICollectionView! {
        didSet {
            personalCollectionView.register(UINib(nibName: "ArtworkPreviewCollectionViewCell",
                bundle: Bundle.main), forCellWithReuseIdentifier: "personalCollectionViewCell")
        }
    }
    @IBOutlet weak var userBackgroundImageView: UIImageView! {
        didSet {
            userBackgroundImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var artworksButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var addArtworkView: AddArtworkView!
    
    private var previews: [ArtworkPreview] = []
    private var localUser: User?
    
    private var collectionViewSelection: Int = 0 {
        didSet {
            if collectionViewSelection != oldValue {
                previews.removeAll()
                artworksButton.setTitleColor(.lightGray, for: .normal)
                favoritesButton.setTitleColor(.lightGray, for: .normal)
                switch collectionViewSelection {
                case 0:
                    artworksButton.setTitleColor(.black, for: .normal)
                case 1:
                    favoritesButton.setTitleColor(.black, for: .normal)
                default:
                    break
                }
                loadProjects() {
                    DispatchQueue.main.async {
                        self.personalCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.sendSubview(toBack: (self.navigationController?.navigationBar)!)
        self.navigationController?.navigationBar.tintColor = .white
        setupAddArtworkView()
        loadLocalUser()
        loadProjects()
        personalCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.view.bringSubview(toFront: (self.navigationController?.navigationBar)!)
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
    
    @IBAction func artworksButtonTapped(_ sender: UIButton) {
        collectionViewSelection = 0
    }
    
    @IBAction func favoritesButtonTapped(_ sender: UIButton) {
        collectionViewSelection = 1
    }
    
    private func setupAddArtworkView() {
        let nib = UINib(nibName: "AddArtworkView", bundle: Bundle.main)
        addArtworkView = nib.instantiate(withOwner: self, options: nil).first as? AddArtworkView
        addArtworkView.useNavigationBarIncludedLayout = true
        self.view.addSubview(addArtworkView)
    }
    
    private func loadLocalUser() {
        if AccountManager.defaultManager.isUserExist() {
            localUser = AccountManager.defaultManager.currentUser
            let portrait = getPersonalPortrait()
            userNameLabel.text = localUser!.name
            largePortraitImageView.image = portrait
        } else {
            let portrait = getPersonalPortrait()
            userNameLabel.text = "Login / Register"
            largePortraitImageView.image = portrait
        }
    }
    
    private func loadProjects(completion: (() -> Void)? = nil) {
        switch collectionViewSelection {
        case 0:
            loadArtworks(completion: completion)
        default:
            break
        }
    }
    
    private func loadArtworks(completion: (() -> Void)? = nil) {
        
    }
    
    private func getPersonalPortrait(useGrayPortrait: Bool = false) -> UIImage {
        var portrait: UIImage!
        if localUser == nil {
            portrait = UIImage(named: (useGrayPortrait ? "" : "White") + "QuestionMark")
        } else if localUser!.portraitPath != nil && localUser!.portraitPath?.count != 0 {
            portrait = DataManager.defaultManager.getImage(path: localUser!.portraitPath!)
        } else {
            portrait = UIImage(named: (useGrayPortrait ? "" : "White") + "User")
        }
        return portrait
    }
    
}


extension PersonalViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "personalCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
        cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ArtworkPreviewCollectionViewCell
        cell.preview = previews[indexPath.row]
        cell.index = indexPath.row
        cell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 20 * 2 - 36 * 2) / 3
        let height = width / 0.967
        return CGSize(width: width, height: height)
    }
}


extension PersonalViewController: ArtworkPreviewDelegate {
    func relayoutCollectionView() {
        
    }
    
    func moreButtonDidTapped(index: Int) {
    }
}
