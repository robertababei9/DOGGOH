//
//  CoreDataOperations.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 29/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataOperations {
    
    static func getDogsCount(entity: String) -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return -1
        }
        var count = 0
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DogModel")
        
        do {
            count = try context.fetch(fetchRequest).count
        }
        catch {
            print("Error trying to fetch data from Core Data")
        }

        return count
    }
    
    static func dogExists(withName name: String, entity: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "breed = %@", name)
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("\n\nError trying to find any dog duplicate\n\n")
        }
        
        return results.count > 0
    }
    
    static func subBreedExists(entity: String, subBreedName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = NSPredicate(format: "name = %@", subBreedName)
        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("\n\nError trying to find any dog duplicate\n\n")
        }

        return results.count > 0
    }
    
    static func saveDog(name: String, image: Data) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //If the dog already exists we return nothing / don't save it
        if self.dogExists(withName: name, entity: "DogModel") == true {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DogModel", in: context)!
        let dogModel = NSManagedObject(entity: entity, insertInto: context)
        dogModel.setValue(name, forKey: "breed")
        dogModel.setValue(image, forKey: "image")
        
        do {
            try context.save()
            
        }
        catch {
            print("Error trying to save data to Core Data")
        }
        
    }
    
    static func setImageForBreed(theImage: NSData, breedName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DogModel")
        fetchRequest.predicate = NSPredicate(format: "breed = %@", breedName)
        
        do {
            let objectDog = try context.fetch(fetchRequest)
            if objectDog.count != 1 {
                return
            }
            let dog = objectDog[0] as? DogModel
            dog?.image = theImage
            
            do {
                try context.save()
            }
            catch {
                print("-----------Error saving image in Core Data---------------")
            }
            
        }
        catch
        {
            print("------------Error trying to fetch from Core Data---------------")
        }
    }
    
    static func setImageForSubBreed(theImage: NSData, subBreedName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SubBreedModel")
        fetchRequest.predicate = NSPredicate(format: "name = %@", subBreedName)
        
        do {
            let objectDog = try context.fetch(fetchRequest)
            if objectDog.count != 1 {
                return
            }
            let dog = objectDog[0] as? SubBreedModel
            dog?.image = theImage
            
            do {
                try context.save()
            }
            catch {
                print("-----------Error saving image for subBreed in Core Data---------------")
            }
            
        }
        catch
        {
            print("------------Error trying to fetch subBreed from Core Data---------------")
        }
    }
    
    static func updateDogWithSubBreeds(name: String, subBreeds: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DogModel")
        fetchRequest.predicate = NSPredicate(format: "breed = %@", name)
        
        do {
          let objectDog = try context.fetch(fetchRequest)
            // no duplicate breed dogs, just 1
            if objectDog.count != 1 {
                return
            }
            
            let dog = objectDog[0] as? DogModel
            for subBreedName in subBreeds {
                if self.subBreedExists(entity: "SubBreedModel", subBreedName: subBreedName) {
                    
                }
                else {
                    let subBreed = SubBreedModel(entity: SubBreedModel.entity(), insertInto: context)
                    subBreed.name = subBreedName
                    subBreed.breedName = name
                    dog?.addToSubBreed(subBreed)
                }

            }
            
            do {
                try context.save()
            }
            catch {
                print("Error updating in Core Data")
            }
            
            
        }
        catch {
            print("Error updating in Core Data")
        }
    }
    
    // Fetch all the dogs from "DogModel" as NSManagedObject
    static func fetchDogData() -> [NSManagedObject] {
        var result: [NSManagedObject] = []
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "DogModel")
        
        do {
            result = try context.fetch(fetchRequest)
        }
        catch {
            print("Error trying to fetch data from Core Data")
        }
        
        return result
    }
    
    static func convertToDogs(fromArray array: [NSManagedObject]) -> [Dog] {
        var allDogs = [Dog]()
        for i in 0 ..< array.count {
            let breedName = array[i].value(forKey: "breed") as? String ?? "NIL"
            var subBreedStringArray = [String]()
            var subBreedObjs = [SubBreed]()
            
            let breedImageNSData = array[i].value(forKey: "image") as? NSData
            let breedImageData = Data(referencing: breedImageNSData!)
//            let breedImage = UIImage(data: breedImageData)
            
            let subBreedSet = array[i].value(forKey: "subBreed") as! NSSet
            let subBreedArray = subBreedSet.allObjects as NSArray
            if subBreedArray.count > 0 {
                subBreedArray.forEach { anyObj in
                    let subBreedModel = anyObj as! SubBreedModel
                    let subBreedModelName = subBreedModel.name as! String
                    let subBreedModelImageData = subBreedModel.image as? Data
//                    let subBreedImage: UIImage
//                    if let subBreedModelImageData = subBreedModelImageData {
//                        subBreedImage = UIImage(data: subBreedModelImageData)!
//                    }
//                    else {
//                        print("--------- I have no image. WTF man ?!?!?!?!? --------")
//                        subBreedImage = UIImage(named: "4")!
//                    }
                    let temporarySubBreedObj = SubBreed(name: subBreedModelName, imageData: subBreedModelImageData)
                    subBreedStringArray.append(subBreedModelName)
                    subBreedObjs.append(temporarySubBreedObj)
                }
            }
            allDogs.append(Dog(dogRace: breedName, dogs: subBreedStringArray, imageData: breedImageData, subBreadDogs2: subBreedObjs))
        }
        return allDogs
    }
}
