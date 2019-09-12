//
//  SubBreedModel+CoreDataProperties.swift
//  
//
//  Created by Robert Ababei on 29/08/2019.
//
//

import Foundation
import CoreData


extension SubBreedModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubBreedModel> {
        return NSFetchRequest<SubBreedModel>(entityName: "SubBreedModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var breedName: String?
    @NSManaged public var image: NSData?

}
