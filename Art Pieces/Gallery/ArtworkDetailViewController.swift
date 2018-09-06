//
//  ArtworkDetailViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/10.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtworkDetailViewController: UIViewController {

    @IBOutlet weak var repositoryTitleImageView: UIImageView! {
        didSet {
            repositoryTitleImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var branchCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .lightGray
    }

    @IBAction func newButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "ArtworkFork", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController() as! ArtworkForkViewController
        viewController.modalPresentationStyle = .formSheet
        self.present(viewController, animated: true, completion: nil)
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

