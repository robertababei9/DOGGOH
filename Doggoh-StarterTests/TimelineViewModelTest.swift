//
//  TimelineViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Robert Ababei on 06/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class TimelineViewModelTest: XCTestCase {

    func testConstructor() {
        // Conditions
        let allDogsManagedObjects = CoreDataOperations.fetchDogData()
        let expectedDogs = CoreDataOperations.convertToDogs(fromArray: allDogsManagedObjects)
        let sut = TimelineViewModel(withDogs: expectedDogs)
        
        // Expectations
        XCTAssertEqual(sut.allDogs.count, expectedDogs.count)
//        XCTAssertEqual(sut.allDogs, expectedDogs)
        var ok = true
        expectedDogs.forEach { dog in
            if sut.allDogs.contains(dog) == false {
                ok = false
            }
        }
        XCTAssertTrue(ok)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
