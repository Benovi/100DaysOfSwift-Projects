//
//  Person.swift
//  Project10
//
//  Created by Ben Oveson on 5/23/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
