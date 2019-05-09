//
//  DetailViewController.swift
//  Milestone-1-3
//
//  Created by Ben Oveson on 5/6/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {
    
    var imageView = UIImageView()
    var image: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = image
        print(image)
    }
    
    
}
