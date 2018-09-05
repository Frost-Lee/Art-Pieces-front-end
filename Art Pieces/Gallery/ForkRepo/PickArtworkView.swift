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
    func artworkSelectionDidChanged()
}

class PickArtworkView: UIView {
    
    @IBOutlet weak var localArtworkCollectionView: UICollectionView! {
        didSet {
            localArtworkCollectionView.register(UINib(nibName:
                "LocalArtworkCollectionViewCell", bundle: Bundle.main),
                forCellWithReuseIdentifier: "localArtworkCollectionViewCell")
            localArtworkCollectionView.reloadData()
        }
    }
    
    weak var delegate: PickArtworkDelegate?
    
    var forkPreviews: [ForkPreview] = []
    
    var selectedIndex: Int?
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        delegate?.nextButtonDidTapped()
    }
    
}

extension PickArtworkView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return forkPreviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "localArtworkCollectionViewCell", for: indexPath) as! LocalArtworkCollectionViewCell
        cell.forkPreview = forkPreviews[indexPath.row]
        if indexPath.row == selectedIndex {
            cell.setSelected()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = collectionView.frame
        let width = (frame.width - 10) / 2.0
        return CGSize(width: width, height: width * 0.87)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndex = selectedIndex {
            if let oldCell = collectionView.cellForItem(at: IndexPath(row: selectedIndex, section: 0))
                as? LocalArtworkCollectionViewCell {
                oldCell.setDeselected()
            }
        }
        let cell = collectionView.cellForItem(at: indexPath) as! LocalArtworkCollectionViewCell
        if indexPath.row == selectedIndex {
            selectedIndex = nil
            cell.setDeselected()
        } else {
            selectedIndex = indexPath.row
            cell.setSelected()
        }
        delegate?.artworkSelectionDidChanged()
    }
}
