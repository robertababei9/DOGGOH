//
//  DogPoolTest.swift
//  Doggoh-StarterTests
//
//  Created by Robert Ababei on 10/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class DogPoolTest: XCTestCase {
    var expectedJSON: [String: AnyObject]!
    var expectedDogs = [Dog]()
    var sut: DogPool!
    var sutDogs: [Dog] = [Dog]()
    
    override func setUp() {
        expectedJSON = DogRepository.getDataFromJSON(withName: DogRepository.fileNameDogTypes)
        expectedDogs = DogPool(dict: expectedJSON).getDogs()
        sut = DogPool(dict: expectedJSON)
        sutDogs = sut.getDogs()
        
        expectedDogs = expectedDogs.sorted {
            $0.breed < $1.breed
        }
        sutDogs = sutDogs.sorted {
            $0.breed < $1.breed
        }
    }
    
    override func tearDown() {
        sut = nil
        sutDogs = [Dog]()
    }
    
    func testDogsAreTheSame() {
        XCTAssertEqual(sutDogs.count, expectedDogs.count)
        for i in 0 ..< sutDogs.count {
            XCTAssertEqual(sutDogs[i], expectedDogs[i])
        }
    }
}
