//
//  DogTableViewModel.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 05/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class DogTableViewModel {
    
    var allDogs: [Dog]
    private let apiClient = DogAPIClient.sharedInstance
    var updateRow: ((Int, Int) -> Void)?
    var updateSection: ((Int) -> Void)?
    
    init(withDogs allDogs: [Dog]) {
        self.allDogs = allDogs
        allDogs.forEach { (dog) in
            if dog.subBreed.isEmpty == false {
                for subBreedName in dog.subBreed {
                    dog.subBreedObj.append(SubBreed(name: subBreedName, imageData: nil))
                }
                CoreDataOperations.updateDogWithSubBreeds(name: dog.breed, subBreeds: dog.subBreed)
            }
        }
    }
    
    func getNumberOfDogs() -> Int{
        return allDogs.count
    }
    
    func getSubBreedCountFromDog(atIndex index: Int) -> Int {
        return allDogs[index].subBreed.count
    }
    
    func getBreedName(atIndex index: Int) -> String{
        return allDogs[index].breed
    }
    
    func getSubBreedName(breedIndex: Int, subBreedIndex: Int) -> String {
        return allDogs[breedIndex].subBreedObj[subBreedIndex].name
    }
    
//    func getBreedViewModel(atIndex index: Int) -> DogCellViewModel {
//        return DogCellViewModel(withDog: allDogs[index])
//    }
    func getDogCellViewModel(breedIndex: Int, subBreedIndex: Int) -> DogCellViewModel {
        let breedName = getBreedName(atIndex: breedIndex)
        
        if allDogs[breedIndex].subBreedObj.count > 0 {
            if subBreedHaveImage(breedIndex: breedIndex, subBreedIndex: subBreedIndex) {
                return DogCellViewModel(withSubBreed: allDogs[breedIndex].subBreedObj[subBreedIndex])
            }
            else {
                let subBreedName = getSubBreedName(breedIndex: breedIndex, subBreedIndex: subBreedIndex)
                
                apiClient.getImageDataBySubBreed(breedName: breedName, subBreedName: subBreedName) { imageData in
                    self.updateSubBreedWithImage(breedIndex: breedIndex, subBreedIndex: subBreedIndex, imageData: imageData)
                    self.updateRow?(breedIndex, subBreedIndex)
                }
                return DogCellViewModel(withSubBreed: allDogs[breedIndex].subBreedObj[subBreedIndex])
            }
        }
        else {
            if breedHaveImage(breedIndex: breedIndex) {
                return DogCellViewModel(withBreed: allDogs[breedIndex])
            }
            else {
                apiClient.getImageDataByBreed(breedName: breedName) { dataImage in
                    self.updateBreedWithImage(atIndex: breedIndex, withImageData: dataImage)
                    self.updateSection?(breedIndex)
                }
                return DogCellViewModel(withBreed: allDogs[breedIndex])
            }
        }
    }
    
    func getDogObject(atIndex index: Int) -> Dog {
        return allDogs[index]
    }
    
//    func getSubBreedViewModel(atDogIndex index: Int, subBreedIndex: Int) -> DogCellViewModel {
//        return DogCellViewModel(withSubBreed: allDogs[index].subBreedObj[subBreedIndex])
//    }
    
    func updateBreedWithImage(atIndex index: Int, withImageData imageData: Data) {
        allDogs[index].setImageWithData(data: imageData)
        CoreDataOperations.setImageForBreed(theImage: imageData as NSData, breedName: allDogs[index].breed)
    }
    
    func updateSubBreedWithImage(breedIndex: Int, subBreedIndex: Int, imageData: Data) {
        allDogs[breedIndex].subBreedObj[subBreedIndex].setImageWithData(data: imageData)
        let subBreedName = allDogs[breedIndex].subBreedObj[subBreedIndex].name
        CoreDataOperations.setImageForSubBreed(theImage: imageData as NSData, subBreedName: subBreedName)
    }
    
    func subBreedHaveImage(breedIndex: Int, subBreedIndex: Int) -> Bool {
        return allDogs[breedIndex].subBreedObj[subBreedIndex].imageData != nil
    }
    
    func breedHaveImage(breedIndex: Int) -> Bool {
        return allDogs[breedIndex].dogImageData != nil
    }
    
}
