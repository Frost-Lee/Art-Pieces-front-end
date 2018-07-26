//
//  ToolPickerTableViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/25.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit

protocol ToolPickerTableViewDelegate {
    func toolSelected(_ tool: Tool)
}


class ToolPickerTableViewController: UITableViewController {
    
    private var toolNames: [String] = ["Gel Pen", "Pencil", "Crayon"]
    
    var delegate: ToolPickerTableViewDelegate?
    
    var selectedTool: Tool = .gelPen {
        didSet {
            tableView.reloadData()
            delegate?.toolSelected(selectedTool)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toolPickerTableViewCell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toolNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toolPickerTableViewCell", for: indexPath)
        cell.textLabel?.text = toolNames[indexPath.row]
        if indexPath.row == selectedTool.index() {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedTool.index() != indexPath.row {
            selectedTool = Tool.toolOfIndex(indexPath.row)
        }
    }

}
