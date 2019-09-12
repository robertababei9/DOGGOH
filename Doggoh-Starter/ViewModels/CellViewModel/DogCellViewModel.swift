//
//  DogCellViewModel.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class DogCellViewModel {
    var dogName: String
    var dogImageData: Data?
    
    init(withBreed breed: Dog) {
        dogName = breed.breed
        dogImageData = breed.dogImageData
    }
    
    init(withSubBreed subBreed: SubBreed) {
        dogName = subBreed.name
        dogImageData = subBreed.imageData
    }
    
}
