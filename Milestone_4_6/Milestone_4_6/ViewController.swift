//
//  ViewController.swift
//  Milestone_4_6
//
//  Created by Ben Oveson on 5/15/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var list = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearItems))
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            if let item = ac.textFields?[0].text {
                self.list.insert(item, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            } else { return }
        }))
        
        present(ac, animated: true)
        
    }
    
    
    @objc func clearItems() {
        list = [String]()
        loadView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
             cell?.accessoryType = .none
        } else {
             cell?.accessoryType = .checkmark
        }
       
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
//        cell.accessoryType = .checkmark
        return cell
    }


}

