//
//  TimelineCellViewModel.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class TimelineCellViewModel {
    let dogName: String
    let dogImageData: Data?
    
    init(withDog dog: Dog) {
        dogName = dog.breed
        dogImageData = dog.dogImageData
    }
    
}
