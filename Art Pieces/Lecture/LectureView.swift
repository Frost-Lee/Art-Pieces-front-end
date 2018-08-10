//
//  Lecture.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol LectureDelegate: class {
    func lectureItemDidSelected(at index: Int)
}

class LectureView: UIView {
    
    @IBOutlet weak var lectureTableView: UITableView! {
        didSet {
            lectureTableView.register(UINib(nibName: "LectureTableViewCell", bundle: Bundle.main),
                                      forCellReuseIdentifier: "lectureTableViewCell")
            lectureTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            lectureTableView.reloadData()
        }
    }
    
    weak var delegate: LectureDelegate?
    
}


extension LectureView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.lectureItemDidSelected(at: indexPath.row)
    }
}
