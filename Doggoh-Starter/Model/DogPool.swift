//
//  DogPool.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 07/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class DogPool {
    private var allDogs: [Dog]
    
    init(dict: Dictionary<String, AnyObject>?) {
        allDogs = [Dog]()
        
        if let dogsDict = dict?["message"] as? [String: [String]] {
            for (key, value) in dogsDict {
                allDogs.append(Dog(dogRace: key, dogs: value))
            }
        }
    }
    
    func getDogs() -> [Dog] {
        return allDogs
    }
    
    
}
