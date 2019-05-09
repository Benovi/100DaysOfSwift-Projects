//
//  ViewController.swift
//  Milestone-1-3
//
//  Created by Ben Oveson on 5/6/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    

    let cellId = "cellId"
    let detailVCId = "flagdetail"
    var indexPathRow = 0

    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("@2x.png") {
                images.append(item)
            }
        }
        print(images)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return images.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        indexPathRow = indexPath.row
        print(images[indexPathRow])
        let vc = DetailViewController()
        vc.title = self.images[indexPathRow]
        self.performSegue(withIdentifier: detailVCId, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == detailVCId {
            
            print(images[indexPathRow])
            print("segue")
    
        }
    }
}
