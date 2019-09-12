//
//  TimelineViewModel.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import CoreData

class TimelineViewModel {
    
    var allDogs: [Dog]
    var cacheImage = [Bool]()
    let apiClient = DogAPIClient.sharedInstance
    var reloadRow: ((Int) -> Void)?
    
    init(withDogs allDogs: [Dog]) {
        self.allDogs = allDogs
        self.allDogs = allDogs.sorted {
            $0.breed < $1.breed
        }
        allDogs.forEach { _ in
            cacheImage.append(false)
        }
    }
    
    func getDogViewModel(withIndex index: Int) -> TimelineCellViewModel {
        if cacheImage[index] == false {
            apiClient.getImageDataByBreed(breedName: allDogs[index].breed) { dataImage in
                self.updateDogWithImage(imageData: dataImage, atIndex: index)
                self.reloadRow?(index)
            }
            cacheImage[index] = true
        }
        return TimelineCellViewModel(withDog: allDogs[index])
    }
    
    
    func updateDogWithImage(imageData: Data, atIndex index: Int) {
        allDogs[index].setImageWithData(data: imageData)
        CoreDataOperations.saveDog(name: self.allDogs[index].breed, image: imageData)
    }
    
    func dogHaveImage(atIndex index: Int) -> Bool {
        return cacheImage[index]
    }
    
    func getDogName(atIndex index: Int) -> String {
        return allDogs[index].breed
    }
    
    func getDogsCount() -> Int {
        return allDogs.count
    }
    
    func getImageDataForDog(atIndex index: Int) -> Data? {
        return allDogs[index].dogImageData
    }
}
