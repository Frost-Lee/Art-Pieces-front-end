//
//  ToolPickerTableViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/25.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol ToolPickerTableViewDelegate {
    func toolSelected(at index: Int)
}


class ToolPickerTableViewController: UITableViewController {
    
    private var toolNames: [String] = ["Gel Pen", "Pencil", "Crayon"]
    
    var delegate: ToolPickerTableViewDelegate?
    
    var selectedTool: Int = 0 {
        didSet {
            tableView.reloadData()
            delegate?.toolSelected(at: selectedTool)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toolPickerTableViewCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toolPickerTableViewCell", for: indexPath)
        cell.textLabel?.text = toolNames[indexPath.row]
        if indexPath.row == selectedTool {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedTool != indexPath.row {
            selectedTool = indexPath.row
        }
    }
    
    static func textureNameFor(index: Int) -> String? {
        switch index {
            case 0: return nil
            case 1: return "PencilTexture"
            case 2: return "CrayonTexture"
            default: return nil
        }
    }
    
    static func textureIndexFor(name: String?) -> Int {
        switch name {
            case nil: return 0
            case "PencilTexture": return 1
            case "CrayonTexture": return 2
            default: return 0
        }
    }

}
