//
//  DogRepository.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 04/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

class DogRepository {
    
    static var fileName = "dog_questions_multiple"
    static var fileNameDogTypes = "dog_types"
    
    static func getDataFromJSON(withName name: String) -> Dictionary<String, AnyObject>?{
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            print("Cannot find JSON file at \(name) path.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                //JSON loaded successfully
//                print("JSON loaded: \(jsonResult)")
                return jsonResult
            }
        } catch let error {
            print("Error opening JSON file: \(error)")
            return nil
        }
        return nil
    }
}
