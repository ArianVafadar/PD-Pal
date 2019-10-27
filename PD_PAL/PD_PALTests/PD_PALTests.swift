//
//  PD_PALTests.swift
//  PD_PALTests
//
//  Created by SpenC on 2019-10-11.
//  Copyright © 2019 WareOne. All rights reserved.
//

import XCTest
@testable import PD_PAL

class PD_PALTests: XCTestCase {

    let exDB = ExerciseDatabase()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //
    func testDatabase_insertion() {
        
        var desc = "Elevate Weights while keepings arms still"
        var cat = "Strength"
        var body = "Arms"
        var name = "Bicep Curls"
        exDB.insert_exercise(Name: name , Desc: desc, Category: cat, Body: body)
        
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
