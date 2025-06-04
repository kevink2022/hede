//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/7/24.
//

import XCTest
@testable import Database

// Conversion packagess
import Models
import Storage
import Assemblages

private typealias T = TestValues

final class AssertionTests: XCTestCase {
    
    // uses old schema
    /*
    func testCoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try? encoder.encode(T.testAssertions)
        
        guard let encoded = encoded else { XCTFail("Failed to encode"); return }
        
        let decoded = try? decoder.decode([Assertion].self, from: encoded)
        
        guard let decoded = decoded else { XCTFail("Failed to encode"); return }
        
        XCTAssertEqual(T.testAssertions, decoded)
    }
     */
}

