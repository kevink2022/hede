//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/7/24.
//

import XCTest
@testable import Database

private typealias T = TestValues

final class AssertionTests: XCTestCase {
    
    func testCoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try? encoder.encode(T.testAssertions)
        
        guard let encoded = encoded else { XCTFail("Failed to encode"); return }
        
        let decoded = try? decoder.decode([Assertion].self, from: encoded)
        
        guard let decoded = decoded else { XCTFail("Failed to encode"); return }
        
        XCTAssertEqual(T.testAssertions, decoded)
    }
}
