//
//  Petition.swift
//  Project7
//
//  Created by Ben Oveson on 5/15/19.
//  Copyright © 2019 Ben Oveson. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
