//
//  ViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/13.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var indicatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(NSHomeDirectory())
        
        var path = NSHomeDirectory()
        path.append("/APDocuments")
        
        try! FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        
        path.append("/object.apdcmt")
        let stroke = Stroke()
        let strokeSample = StrokeSample(timeStamp: TimeInterval(4.29), location: CGPoint(x: 4.2, y: 4.9))
        stroke.add(sample: strokeSample)
        storeAnObject(stroke, at: path)
        
        if FileManager.default.fileExists(atPath: path) {
            if let stroke = loadAnObject(from: path) {
                let timeInterval = stroke.samples.first?.timeStamp
                indicatorLabel.text = timeInterval?.description
            } else {
                indicatorLabel.text = "Failed in loading process."
            }
        } else {
            let stroke = Stroke()
            let strokeSample = StrokeSample(timeStamp: TimeInterval(4.29), location: CGPoint(x: 4.2, y: 4.9))
            stroke.add(sample: strokeSample)
            storeAnObject(stroke, at: path)
        }
    }
    
    private func storeAnObject(_ stroke: Stroke, at path: String) {
        do {
            print(path)
            let dataToWrite = try JSONEncoder().encode(stroke) as NSData
            dataToWrite.write(toFile: path, atomically: false)
        } catch {
            indicatorLabel.text = "Data cannot be written to the disk."
        }
    }
    
    private func loadAnObject(from path: String) -> Stroke? {
        do {
            let loadedData = try NSData(contentsOfFile: path) as Data
            let stroke = try JSONDecoder().decode(Stroke.self, from: loadedData)
            return stroke
        } catch {
            indicatorLabel.text = "Data cannot be loaded from the disk."
        }
        return nil
    }
    
}

