//
//  DogTableViewModelTest.swift
//  Doggoh-StarterTests
//
//  Created by Robert Ababei on 09/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import XCTest
@testable import Doggoh_Starter

class DogTableViewModelTest: XCTestCase {
    
    let apiClient = DogAPIClient.sharedInstance
    var expectation: XCTestExpectation!
    var sut: DogTableViewModel!
    var expectedDogs: [Dog]!
    
    override func setUp() {
        
        expectation = expectation(description: "All dogs have been fetched")
        
        expectedDogs = [Dog]()
        apiClient.getAllDogs_v2 {[weak self] allDogs in
            self?.expectedDogs = allDogs
            self?.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
        sut = DogTableViewModel(withDogs: expectedDogs)
        sut.allDogs = sut.allDogs.sorted {
            $0.breed < $1.breed
        }
        expectedDogs = expectedDogs.sorted {
            $0.breed < $1.breed
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDogsAreTheSame() {
        XCTAssertEqual(sut.allDogs.count, expectedDogs.count)
        for i in 0 ..< expectedDogs.count {
            XCTAssertEqual(sut.allDogs[i].subBreed, expectedDogs[i].subBreed)
            XCTAssertEqual(sut.allDogs[i].subBreedObj.count, expectedDogs[i].subBreed.count)
        }
    }
    
//    func testUpdateRowIsCalled() {
//        // asigura te ca sut nu are imagini sau ceva
//        //
//        let reloadExpectation = expectation(description: "jsjksjsjs")
//        sut.updateRow = { row , sect in
//            //verifc daca update e corect pt row si section
//            //if corect
//            reloadExpectation.fulfill()
//        }
//
//        // apelez ceva din sut, ca apoi sut-ul sa iti apeleze update-row-ul aici
//        //getDogCellViewModel
//        waitForExpectations(timeout: 2, handler: nil)
//
//    }
    
}
