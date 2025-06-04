//
//  hedeTests.swift
//  hedeTests
//
//  Created by Kevin Kelly on 8/30/24.
//

import XCTest
@testable import hede
@testable import Database
import Storage
import Assemblages

final class hedeTests: XCTestCase {

    func test_codeMocks() throws {
        let schedulers = PreviewMocks.schedulers
        let tasks = PreviewMocks.tasks
        
        let savable: [any Savable] = schedulers + tasks
        
        let assertions = savable.map { Assertion($0) }
        let assertionSet = KeySet<Assertion>(assertions)
        let event = UserEventLog(label: "Test Preview Assertions", assertions: assertionSet)
        let transaction = DataTransaction<UserEventLog>(event)
        
        do {
            let assertions_data = try JSONEncoder().encode(assertions)
            let assertionSet_data = try JSONEncoder().encode(assertionSet)
            let event_data = try JSONEncoder().encode(event)
            let transaction_data = try JSONEncoder().encode(transaction)
            
            print("assertions_data: \(assertions.asJsonString() ?? "null")")
            print("assertionSet_data: \(assertionSet.asJsonString() ?? "null")")
            print("event_data: \(event.asJsonString() ?? "null")")
            print("transaction_data: \(transaction.asJsonString() ?? "null")")
        } catch {
            XCTFail("Failed to encode: \(error.localizedDescription)")
        }
    }
    
    func test_codeGoalMocks() throws {
        let schedulers = PreviewMocks.goals
        let tasks = PreviewMocks.lists
        let sections = PreviewMocks.sections
        
        let savable: [any Savable] = schedulers + tasks + sections
        
        let assertions = savable.map { Assertion($0) }
        let assertionSet = KeySet<Assertion>(assertions)
        let event = UserEventLog(label: "Test Preview Assertions", assertions: assertionSet)
        let transaction = DataTransaction<UserEventLog>(event)
        
        do {
            let assertions_data = try JSONEncoder().encode(assertions)
            let assertionSet_data = try JSONEncoder().encode(assertionSet)
            let event_data = try JSONEncoder().encode(event)
            let transaction_data = try JSONEncoder().encode(transaction)
            
            print("assertions_data: \(assertions.asJsonString() ?? "null")")
            print("assertionSet_data: \(assertionSet.asJsonString() ?? "null")")
            print("event_data: \(event.asJsonString() ?? "null")")
            print("transaction_data: \(transaction.asJsonString() ?? "null")")
        } catch {
            XCTFail("Failed to encode: \(error.localizedDescription)")
        }
    }
}
