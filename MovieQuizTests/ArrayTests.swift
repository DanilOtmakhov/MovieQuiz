//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Danil Otmakhov on 03.12.2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    
    func testGetValueInRange() throws {
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 8]
        
        XCTAssertNil(value)
    }
}
