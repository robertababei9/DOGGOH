//
//  Dog.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import Foundation

class Dog {
    var dogRace: String
    var dogs: [String]
    var dogImage: UIImage?
    
    init(dogRace: String, dogs: [String]) {
        self.dogRace = dogRace
        self.dogs = dogs
        let rnd = Int.random(in: 0...22)
        dogImage = UIImage(named: "\(rnd)")
    }
}
