//
//  DogModel+CoreDataProperties.swift
//  
//
//  Created by Robert Ababei on 29/08/2019.
//
//

import Foundation
import CoreData


extension DogModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DogModel> {
        return NSFetchRequest<DogModel>(entityName: "DogModel")
    }

    @NSManaged public var breed: String?
    @NSManaged public var image: NSData?
    @NSManaged public var subBreed: NSSet?

}

// MARK: Generated accessors for subBreed
extension DogModel {

    @objc(addSubBreedObject:)
    @NSManaged public func addToSubBreed(_ value: SubBreedModel)

    @objc(removeSubBreedObject:)
    @NSManaged public func removeFromSubBreed(_ value: SubBreedModel)

    @objc(addSubBreed:)
    @NSManaged public func addToSubBreed(_ values: NSSet)

    @objc(removeSubBreed:)
    @NSManaged public func removeFromSubBreed(_ values: NSSet)

}
