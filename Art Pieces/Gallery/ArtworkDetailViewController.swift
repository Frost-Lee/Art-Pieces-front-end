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
    let dataManager = DataManager.defaultManager
    
    let branchCollectionViewPlaceHolder = UIImage(named: "LecturePlaceHolderImage")
    
    var preview: ArtworkPreview!
    var branchPreviews: [BranchPreview] = []
    var keyPhotoDictionary: [UUID : String?] = [:] {
        didSet {
            var indicesToUpdate: [IndexPath] = []
            for key in keyPhotoDictionary.keys {
                if oldValue[key] == nil {
                    for i in 0 ..< branchPreviews.count {
                        if branchPreviews[i].uuid == key {
                            indicesToUpdate.append(IndexPath(row: i, section: 0))
                            break
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.branchCollectionView.reloadItems(at: indicesToUpdate)
            }
        }
    }
    
    var keyPhoto: UIImage?
    var creatorPortrait: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
        initializeCachedFields()
        beginFetchingKeyPhoto()
        beginFetchingBranches()
        beginFetchingPortraitPhoto()
        repositoryTitleImageView.addGestureRecognizer(UIGestureRecognizer(target: self, action:
            #selector(keyImageViewTapped)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showKeyPhoto":
            if sender != nil {
                let destination = segue.destination as! KeyPhotoViewController
                if sender is UIImage {
                    destination.keyPhotoImageView.image = sender as? UIImage
                } else {
                    destination.keyPhotoImageView.image = DataManager.defaultManager.getImage(path: sender as! String)
                }
            }
        default:
            break
        }
    }

    @IBAction func newButtonTapped(_ sender: UIButton) {
        if AccountManager.defaultManager.isUserExist() {
            let viewController = ArtworkForkViewController()
            viewController.currentRepoID = preview.uuid
            viewController.currentRepoName = preview.title
            present(viewController, animated: true, completion: nil)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            present(storyboard.instantiateInitialViewController()!, animated: true, completion: nil)
        }
    }
    
    @objc private func keyImageViewTapped() {
        performSegue(withIdentifier: "showKeyPhoto", sender: repositoryTitleImageView.image)
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
    
    private func beginFetchingBranches() {
        webManager.getRepoArtworks(repoID: preview.uuid) { branches in
            self.branchPreviews = branches
            for branch in branches {
                self.webManager.fetchPhoto(url: URL(string: branch.keyPhotoPath)!) { image in
                    if let image = image {
                        self.keyPhotoDictionary[branch.uuid] =
                            self.dataManager.saveImage(photo: image, isCachedPhoto: true)
                    }
                }
            }
            DispatchQueue.main.async {
                self.branchCollectionView.reloadData()
            }
        }
    }
    
}


extension ArtworkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return branchPreviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCollectionViewCell",
                                                      for: indexPath) as! BranchCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
        cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! BranchCollectionViewCell
        cell.index = indexPath.row
        cell.delegate = self
        if keyPhotoDictionary[branchPreviews[indexPath.row].uuid] != nil {
            let image = dataManager.getImage(path: keyPhotoDictionary[branchPreviews[indexPath.row].uuid]!!)
            cell.branchKeyPhoto.image = image
        } else {
            cell.branchKeyPhoto.image = branchCollectionViewPlaceHolder
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.0, height: collectionView.frame.height / 2.0)
    }
}


extension ArtworkDetailViewController: BranchCollectionViewDelegate {
    func branchDetailShouldShow(index: Int) {
        performSegue(withIdentifier: "showKeyPhoto", sender: keyPhotoDictionary[branchPreviews[index].uuid] ?? nil)
    }
}



