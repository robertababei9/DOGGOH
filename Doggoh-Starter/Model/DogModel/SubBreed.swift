//
//  SubBreed.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit

class SubBreed {
    var name: String
    var imageData: Data?
    
    init(name: String, imageData: Data?) {
        self.name = name
        self.imageData = imageData
    }
    
    func setImageWithData(data: Data) {
        imageData = data
    }
}
