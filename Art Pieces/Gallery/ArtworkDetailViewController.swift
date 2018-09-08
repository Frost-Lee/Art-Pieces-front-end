//
//  ArtworkDetailViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/10.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtworkDetailViewController: UIViewController {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var creatorNameLabel: UILabel!
    @IBOutlet weak var creatorPortraitImageView: UIImageView!
    @IBOutlet weak var forkNumberLabel: UILabel!
    @IBOutlet weak var starNumberLabel: UILabel!
    @IBOutlet weak var repositoryTitleImageView: UIImageView! {
        didSet {
            repositoryTitleImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var branchCollectionView: UICollectionView!
    
    let webManager = APWebService.defaultManager
    
    var preview: ArtworkPreview!
    
    var keyPhoto: UIImage?
    var creatorPortrait: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
        initializeCachedFields()
        beginFetchingKeyPhoto()
        beginFetchingPortraitPhoto()
    }

    @IBAction func newButtonTapped(_ sender: UIButton) {
        let viewController = ArtworkForkViewController()
        viewController.currentRepoID = preview.uuid
        present(viewController, animated: true, completion: nil)
    }
    
    private func initializeCachedFields() {
        repositoryNameLabel.text = preview.title
        creatorNameLabel.text = preview.creatorName
        forkNumberLabel.text = String(preview.numberOfForks)
        starNumberLabel.text = String(preview.numberOfStars)
    }
    
    private func beginFetchingKeyPhoto() {
        if keyPhoto != nil {
            repositoryTitleImageView.image = keyPhoto
        } else {
            webManager.fetchPhoto(url: URL(string: preview.keyPhotoPath)!) { image in
                self.keyPhoto = image
                DispatchQueue.main.async {
                    self.repositoryTitleImageView.image = image
                }
            }
        }
    }
    
    private func beginFetchingPortraitPhoto() {
        if creatorPortrait != nil {
            creatorPortraitImageView.image = creatorPortrait
        } else if preview.creatorPortraitPath == nil {
            creatorPortraitImageView.image = UIImage(named: "User")
        } else {
            webManager.fetchPhoto(url: URL(string: preview.creatorPortraitPath!)!) { image in
                self.creatorPortrait = image
                DispatchQueue.main.async {
                    self.creatorPortraitImageView.image = image
                }
            }
        }
    }
    
}


extension ArtworkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCollectionViewCell",
                                                      for: indexPath) as! BranchCollectionViewCell
        cell.branchKeyPhoto.image = UIImage(named: "LecturePlaceHolderImage")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.0, height: collectionView.frame.height / 2.0)
    }
}

