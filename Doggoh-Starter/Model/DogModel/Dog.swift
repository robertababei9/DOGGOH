//
//  Dog.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import Foundation

class Dog: Equatable {
    var breed: String
    var subBreed: [String]
    var dogImageData: Data?
    var subBreedObj: [SubBreed]
    
    init(dogRace: String, dogs: [String]) {
        self.breed = dogRace
        self.subBreed = dogs
        self.subBreedObj = [SubBreed]()
        subBreedObj = [SubBreed]()
    }
    
    init(dogRace: String, dogs: [String], imageData: Data?, subBreadDogs2: [SubBreed]) {
        breed = dogRace
        subBreed = dogs
        dogImageData = imageData
        subBreedObj = subBreadDogs2
    }
    
    func setImageWithData(data: Data) {
        dogImageData = data
    }
    
    static func == (lhs: Dog, rhs: Dog) -> Bool{
        return lhs.breed == rhs.breed
    }
    
}

extension Array where Element: Comparable {
    func containSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
