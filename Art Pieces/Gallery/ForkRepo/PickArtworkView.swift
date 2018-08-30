//
//  PickArtworkView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/30.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol PickArtworkDelegate: class {
    func nextButtonDidTapped()
    func artworkDidSelected(at index: Int)
}

class PickArtworkView: UIView {
    
    @IBOutlet weak var localArtworkCollectionView: UICollectionView! {
        didSet {
            localArtworkCollectionView.register(UINib(nibName:
                "LocalArtworkCollectionViewCell", bundle: Bundle.main),
                forCellWithReuseIdentifier: "localArtworkCollectionViewCell")
            localArtworkCollectionView.delegate = self
        }
    }
    
    weak var delegate: PickArtworkDelegate?
    
    var selectedIndex: Int?
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.nextButtonDidTapped()
    }
    
}

extension PickArtworkView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "localArtworkCollectionViewCell", for: indexPath) as! LocalArtworkCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            let oldCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0))
                as! LocalArtworkCollectionViewCell
            oldCell.setDeselected()
        }
        let cell = collectionView.cellForItem(at: indexPath) as! LocalArtworkCollectionViewCell
        selectedIndex = indexPath.row
        cell.setSelected()
    }
}
