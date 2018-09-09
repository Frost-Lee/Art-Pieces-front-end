//
//  ArtboardsGalleryViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/9.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ArtboardsGalleryViewController: UIViewController {
    
    var artboards: [MyArtboard] = []
    
    let dataManager = DataManager.defaultManager
    
    @IBOutlet weak var artboardsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        artboards = dataManager.getAllArtboards()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let destination = segue.destination as! ArtboardEditViewController
        
        destination.artboard = sender as? MyArtboard
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        artboardsCollectionView.reloadData()
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ArtboardsGalleryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artboards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "artboardPreviewCollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
        cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ArtboardPreviewCollectionViewCell
        cell.keyPhoto = dataManager.getImage(path: artboards[indexPath.row].keyPhotoPath!)
        cell.index = indexPath.row
        cell.titleTextField.text = artboards[indexPath.row].title
        cell.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editArtboard", sender: artboards[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 80) / 3
        return CGSize(width: width, height: width / 4.0 * 3.0 + 46)
    }
}


extension ArtboardsGalleryViewController: ArtboardPreviewDelegate {
    func artboardNameDidChanged(at index: Int, to name: String) {
        dataManager.updateArtboard(title: name, uuid: artboards[index].uuid!)
    }
    
    func artboardNameBeginEditting(at index: Int) {
        // Prevent from overlying
    }
    
    func moreButtonDidTapped(at index: Int, sender: UIButton) {
        let alert = UIAlertController(title: "About Artboard", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Remove", style: .destructive) { action in
            self.dataManager.removeArtboard(uuid: self.artboards[index].uuid!)
            self.artboards.removeAll()
            self.artboards = self.dataManager.getAllArtboards()
            self.artboardsCollectionView.reloadData()
        }
        alert.addAction(deleteAction)
        alert.popoverPresentationController?.sourceRect = sender.bounds
        alert.popoverPresentationController?.sourceView = sender
        present(alert, animated: true, completion: nil)
    }
}
