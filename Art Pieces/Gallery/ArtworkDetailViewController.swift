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

        // Do any additional setup after loading the view.
    }

}


extension ArtworkDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branchCollectionViewCell",
                                                      for: indexPath) as! BranchCollectionViewCell
        cell.branchKeyPhoto.image = UIImage(named: "LecturePlaceHolderImage")
        return cell
    }
}
