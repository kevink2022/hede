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
    
    func testCoding() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        let encoded = try? encoder.encode(T.testAssertions)
        
        guard let encoded = encoded else { XCTFail("Failed to encode"); return }
        
        let decoded = try? decoder.decode([Assertion].self, from: encoded)
        
        guard let decoded = decoded else { XCTFail("Failed to encode"); return }
        
        XCTAssertEqual(T.testAssertions, decoded)
    }
    
    func testIndividualConversion() throws {
        guard let transactions = try? JSONDecoder().decode([DataTransaction<UserEventLog>].self, from: oldSchemaData)
        else { XCTFail("Failed to decode schema data"); return }
        
        // 92 assertions
        print(transactions.count)
        
        let assertionSets = transactions.map { $0.data.assertions }
        let assertions = assertionSets.reduce([Assertion](), { partialResult, assertionSet in
            partialResult + assertionSet.values
        })
        
        // 92 assertions
        print(assertions.count)
        
        let sorted = assertions.reduce((sources: [AnyTaskSource](), tasks: [AnyTask]()), { partialResult, assertion in
            
            let code = assertion.assertCode
            
            if case .source(let anySource) = code {
                return (
                    sources: partialResult.sources + [anySource]
                    , tasks: partialResult.tasks
                )
            }
            
            if case .task(let anyTask) = code {
                return (
                    sources: partialResult.sources
                    , tasks: partialResult.tasks + [anyTask]
                )
            }
            
            return partialResult
        })
        
        let sources = sorted.sources
        let tasks = sorted.tasks
        
        // 11 sources
        print(sources.count)
        // 81 tasks
        print(tasks.count)
        
        let schedulersFromAssertions = sources.map { HedeScheduler(convert: $0) }
        let tasksFromAssertions = tasks.map { HedeTask(convert: $0) }
        
        XCTAssertEqual(schedulersFromAssertions.count, sources.count)
        XCTAssertEqual(tasksFromAssertions.count, tasks.count)
        
        let basis = BasisResolver<TaskBasis>(.empty).commit(Assertion.flatten(assertionSets))
        
        //
        print(basis.taskSources.count)
        //
        print(basis.tasks.count)
        
        let schedulersFromBasis = basis.taskSources.map { HedeScheduler(convert: $0) }
        let tasksFromBasis = basis.tasks.map { HedeTask(convert: $0) }
        
        XCTAssertEqual(schedulersFromBasis.count, basis.taskSources.count)
        XCTAssertEqual(tasksFromBasis.count, basis.tasks.count)
    }
    
    func testFullConversion() async {
        let testKey = StorageKey(namespace: nil, key: "TEST_CONVERSION", version: 0)
        
        // Setting up the current state
        guard let historicalTransactions = try? JSONDecoder().decode([DataTransaction<UserEventLog>].self, from: oldSchemaData)
        else { XCTFail("Failed to decode schema data"); return }
        
        let historyStore = SimpleStore<[DataTransaction<UserEventLog>]>(key: testKey, cached: false, inMemory: true)
        
        do { try await historyStore.save(historicalTransactions) }
        catch { XCTFail("Failed to save historical data."); return }
        
        // Generate the conversion transactions
        let conversionStore = SimpleStore<[DataTransaction<UserEventLog>]>(key: testKey, cached: false, inMemory: true)
        
        guard let conversionTransactions = try? await conversionStore.load()
        else { XCTFail("Failed to load conversion transactions"); return }
        
        let assertionConversionScript: (KeySet<Assertion>) -> KeySet<Assertion> = { assertionSet in
            
            assertionSet.reduce(KeySet<Assertion>()) { newSet, assertion in
                
                let convertedAssertion = {
                    switch assertion.assertCode {
                    case .source(let source): Assertion(HedeScheduler(convert: source))
                    case .task(let task): Assertion(HedeTask(convert: task))
                    default: assertion
                    }
                }()
                
                return newSet.updating(with: convertedAssertion)
            }
        }
        
        let eventConversionScript: (UserEventLog) -> UserEventLog = {
            event in event.convert(with: assertionConversionScript)
        }
        
        let convertedTransactions = conversionTransactions.map { transaction in
            transaction.convert(with: eventConversionScript)
        }
        
        // Verify conversion integrity
        print("Historical: \(historicalTransactions.count)\nConverted: \(convertedTransactions.count)")
        XCTAssertEqual(convertedTransactions.count, historicalTransactions.count)
        
        let assertionSetsFromTransaction: ([DataTransaction<UserEventLog>]) -> [KeySet<Assertion>] = {
            transactions in transactions.reduce([KeySet<Assertion>()]) { assertionSets, transaction in
                assertionSets + [transaction.data.assertions]
            }
        }
        
        let historicalAssertionSets: [KeySet<Assertion>] = assertionSetsFromTransaction(historicalTransactions)
        let historicalFlattenedAssertions = Assertion.flatten(historicalAssertionSets)
        let historicalBasis = BasisResolver<TaskBasis>(.empty).commit(historicalFlattenedAssertions)
        
        let convertedAssertionSets: [KeySet<Assertion>] = assertionSetsFromTransaction(convertedTransactions)
        let convertedFlattenedAssertions = Assertion.flatten(convertedAssertionSets)
        let convertedBasis = BasisResolver<TaskBasis>(.empty).commit(convertedFlattenedAssertions)
        
        print("Historical Sources: \(historicalBasis.taskSources.count)\nConverted Schedulers: \(convertedBasis.hedeSchedulers.count)")
        XCTAssertEqual(historicalBasis.taskSources.count, convertedBasis.hedeSchedulers.count)
        
        print("Historical Tasks: \(historicalBasis.tasks.count)\nConverted Tasks: \(convertedBasis.hedeTasks.count)")
        XCTAssertEqual(historicalBasis.tasks.count, convertedBasis.hedeTasks.count)
        
        print("Converted Sources: \(convertedBasis.taskSources.count)\nConverted DEPR Tasks: \(convertedBasis.tasks.count)")
        XCTAssertEqual(convertedBasis.taskSources.count, 0)
        XCTAssertEqual(convertedBasis.tasks.count, 0)
        
        // Save converted data
//        do { try await conversionStore.save(convertedTransactions) }
//        catch { XCTFail("Failed to save converted data."); return }
        
        // Init transactor on the same key
        
    }
}

