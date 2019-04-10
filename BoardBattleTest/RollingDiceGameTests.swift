//
//  RollingDiceGameTests.swift
//  RollingDiceGameTests
//
//  Created by Kulpreet Singh on 2019-03-10.
//  Copyright © 2019 Kulpreet Singh. All rights reserved.
//

import XCTest
@testable import RollingDiceGame

class RollingDiceGameTests: XCTestCase {
    
    var gameClass = GameScene()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPosition100() {
        
        let position = gameClass.calculatePlayerPosition(position: 100)
        XCTAssertEqual(position, CGPoint(x: 10, y: 1))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
