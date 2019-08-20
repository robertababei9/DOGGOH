//
//  MultipleDogImagesURL.swift
//  Doggoh-Starter
//
//  Created by Robert Ababei on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import Foundation

struct MultipleDogImageURL: Codable {
    let randomDogImages: [String]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case randomDogImages = "message"
        case status = "status"
    }
}
