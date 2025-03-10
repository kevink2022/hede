//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/4/24.
//

import Foundation
import Models
import Storage
import Domain
import Assemblages

/// Public dummy protocol of what can be saved in the database. Not to be added to anything.
public protocol Savable: Codable, Identifiable, Equatable {
    var id: Key { get }
}

/// Internal implementation of Savable.
internal protocol Assertable: Savable {
    var assertCode: AssertionCode { get }
}

internal enum AssertionCode: Codable, Equatable {
    case delete(DeleteKey)
    
    // Tasks
    case task(AnyTask)
    case source(AnyTaskSource)
    case category(TaskCategory)
    case pause(TaskPause)
    
    // Goals
    case dailyGoal(DailyGoal)
    case dailyGoalResult(DailyGoalResult)
    case dailyGoalList(DailyGoalList)
    case dailyGoalListSection(DailyGoalListSection)
    case routine(Routine)
    case routineStep(RoutineStep)
    case routineResult(RoutineResult)
    case routineStepResult(RoutineStepResult)
}

internal final class DeleteKey: Assertable {
   
    internal let id: Key
    internal var assertCode: AssertionCode { .delete(self) }
    
    init(_ id: Key) {
        self.id = id
    }
    
    static func == (lhs: DeleteKey, rhs: DeleteKey) -> Bool {
        lhs.id == rhs.id
    }
}

internal final class Assertion: Assertable {
    static func == (lhs: Assertion, rhs: Assertion) -> Bool {
        lhs.assertCode == rhs.assertCode
    }
    
    internal let data: any Assertable
    internal var assertCode: AssertionCode { data.assertCode }
    internal var id: Key { data.id }
    
    init(_ data: any Assertable) {
        self.data = data
    }
    
    init(_ data: any Savable) {
        self.data = data as! any Assertable
    }
}

extension AnyTask: Assertable { var assertCode: AssertionCode { .task(self) } }
extension AnyTaskSource: Assertable { var assertCode: AssertionCode { .source(self) } }
extension TaskCategory: Assertable { var assertCode: AssertionCode { .category(self) } }
extension TaskPause: Assertable { var assertCode: AssertionCode { .pause(self) } }

extension DailyGoal: Assertable { var assertCode: AssertionCode { .dailyGoal(self) } }
extension DailyGoalResult: Assertable { var assertCode: AssertionCode { .dailyGoalResult(self) } }
extension DailyGoalList: Assertable { var assertCode: AssertionCode { .dailyGoalList(self) } }
extension DailyGoalListSection: Assertable { var assertCode: AssertionCode { .dailyGoalListSection(self) } }
extension Routine: Assertable { var assertCode: AssertionCode { .routine(self) } }
extension RoutineStep: Assertable { var assertCode: AssertionCode { .routineStep(self) } }
extension RoutineResult: Assertable { var assertCode: AssertionCode { .routineResult(self) } }
extension RoutineStepResult: Assertable { var assertCode: AssertionCode { .routineStepResult(self) } }

extension Assertion {
    internal convenience init(code: AssertionCode) {
        switch code {
        case .delete(let data): self.init(data)
        case .task(let data): self.init(data)
        case .source(let data): self.init(data)
        case .category(let data): self.init(data)
        case .pause(let data): self.init(data)
        case .dailyGoal(let data): self.init(data)
        case .dailyGoalResult(let data): self.init(data)
        case .dailyGoalList(let data): self.init(data)
        case .dailyGoalListSection(let data): self.init(data)
        case .routine(let data): self.init(data)
        case .routineStep(let data): self.init(data)
        case .routineResult(let data): self.init(data)
        case .routineStepResult(let data): self.init(data)
        }
    }
    
    internal enum CodingKeys: String, CodingKey {
        case assertCode
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data.assertCode, forKey: .assertCode)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(AssertionCode.self, forKey: .assertCode)
        self.init(code: code)
    }
    
    /// Flatten an array of assertion keysets into a single one. Earlier indexes represent earlier assertions
    internal static func flatten(_ assertionSets: [KeySet<Assertion>]) -> KeySet<Assertion> {
        let count = assertionSets.count
        guard count != 0 else { return KeySet() }
        if count == 1 { return assertionSets.first! }
        
        let middle = count/2
        
        let older = flatten(Array(assertionSets.prefix(middle)))
        let newer = flatten(Array(assertionSets.suffix(from: middle)))
    
        return union(older: older, newer: newer)
    }
    
    /// Combine two key sets of assertion.
    private static func union(older: KeySet<Assertion>, newer: KeySet<Assertion>) -> KeySet<Assertion> {
        
        var merged = KeySet<Assertion>()
        
        older.forEach { olderAssertion in
            if let newerAssertion = newer[olderAssertion] {
                merged.insert(newerAssertion)
            } else {
                merged.insert(olderAssertion)
            }
        }
        
        newer.forEach { rightAssertion in
            if !merged.contains(rightAssertion) {
                merged.insert(rightAssertion)
            }
        }
        
        return merged
    }
}







