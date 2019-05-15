//
//  ViewController.swift
//  Project7
//
//  Created by Ben Oveson on 5/15/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filtered = [Petition]()
    var filteredBool = [false,true]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "WH Petitions"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditAlert))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        
        var urlString: String
        
        if tabBarController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
  
        
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
            showError()
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Enter Filter Word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (action) in
            if self.filteredBool[0] {
                self.filteredBool[0].toggle()
                self.tableView.reloadData()
            } else { return }
            
        }))
        ac.addAction(UIAlertAction(title: "Filter", style: .default, handler: { (action) in
            for petition in self.petitions {
                let title: String = petition.title
                let text: String = ac.textFields?[0].text ?? ""
                
                if title.contains(text) {
                    self.filtered.append(petition)
                }
            }
            self.filteredBool[0].toggle()
            self.tableView.reloadData()
            
        }))
        present(ac, animated: true)
    }
    
    @objc func creditAlert() {
        let ac = UIAlertController(title: "API Source", message: "From the We The People API of the Whitehouse.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "Connection Issues. Please check connection and try again.", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int
        
        if filteredBool[0] {
            rows = filtered.count
        } else {
            rows = petitions.count
        }
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var pet = petitions[indexPath.row]
        if filteredBool[0] {
            pet = filtered[indexPath.row]
        } else {
            pet = petitions[indexPath.row]
        }
        cell.textLabel?.text = pet.title
        cell.detailTextLabel?.text = pet.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var pet = petitions[indexPath.row]
        if filteredBool[0] {
            pet = filtered[indexPath.row]
        } else {
            pet = petitions[indexPath.row]
        }
        let vc = DetailViewController()
        vc.detailItem = pet
        navigationController?.pushViewController(vc, animated: true)
    }

}

