//
//  DailyGoals.swift
//  Models
//
//  Created by Kevin Kelly on 2/23/25.
//

import Foundation
import Domain
import Assemblages

/// A daily goal is something to be done/tracked daily.
public final class DailyGoal: Codable, Identifiable, Equatable  {
    public let id: Key
    
    /// The name of the goal.
    public let label: String
    /// An optional description of the goal
    public let description: String?
    /// The type of goal
    public let config: GoalResult.Config
    /// Whether the goal is a positive behavior (more is better) or negative
    public let type: GoalType
    /// Whether the goal is acitvely being tracked
    public let active: Bool
    
    public static func == (lhs: DailyGoal, rhs: DailyGoal) -> Bool {
        lhs.id == rhs.id
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.config == rhs.config
        && lhs.type == rhs.type
        && lhs.active == rhs.active
    }
    
    internal init(
        id: Key
        , label: String
        , description: String?
        , config: GoalResult.Config
        , type: GoalType
        , active: Bool
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.config = config
        self.type = type
        self.active = active
    }
    
    public static func new(
        label: String
        , description: String?
        , config: GoalResult.Config
        , type: GoalType
    ) -> DailyGoal {
        
        DailyGoal(
            id: .new()
            , label: label
            , description: description
            , config: config
            , type: type
            , active: true
        )
    }
    
    public func edit(
        label: String? = nil
        , description: String? = nil
        , config: GoalResult.Config? = nil
        , type: GoalType? = nil
        , active: Bool? = nil
    ) -> DailyGoal {
        
        return DailyGoal(
            id: self.id
            , label: label ?? self.label
            , description: description.null(or: self.description)
            , config: config ?? self.config
            , type: type ?? self.type
            , active: active ?? self.active
        )
    }
    
    public func complete(
        date: Date
        , result: GoalResult
    ) -> DailyGoalResult {
        
        DailyGoalResult(
            id: .new()
            , dailyGoalId: self.id
            , label: self.label
            , result: result
            , date: date.startOfDay
            , recorded: .now
        )
    }
    
    public var asResult: DailyGoalResult {
        DailyGoalResult(
            id: .new()
            , dailyGoalId: self.id
            , label: self.label
            , result: self.config.empty
            , date: .today
            , recorded: .now
        )
    }
}

/// A daily goal result is an instance of a completed goal
public final class DailyGoalResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The ID of the goal itself
    public let dailyGoalId: Key
    /// The label of the goal at the time
    public let label: String
    /// The result of the goal
    public let result: GoalResult
    /// The date the goal was performed
    public let date: Date
    /// the time the goal result was recorded
    public let recorded: Date
    
    public static func == (lhs: DailyGoalResult, rhs: DailyGoalResult) -> Bool {
        lhs.id == rhs.id
        && lhs.label == rhs.label
        && lhs.result == rhs.result
        && lhs.date == rhs.date
        && lhs.recorded == rhs.recorded
    }
    
    internal init(
        id: Key
        , dailyGoalId: Key
        , label: String
        , result: GoalResult
        , date: Date
        , recorded: Date
    ) {
        self.id = id
        self.dailyGoalId = dailyGoalId
        self.label = label
        self.result = result
        self.date = date
        self.recorded = recorded
    }
    
    public func complete(
        date: Date
        , result: GoalResult
    ) -> DailyGoalResult {
        
        DailyGoalResult(
            id: self.id
            , dailyGoalId: self.dailyGoalId
            , label: self.label
            , result: result
            , date: date
            , recorded: .now
        )
    }
}

public enum GoalType: String, Codable, Equatable, CaseIterable {
    /// Something one is encouraging
    case positive = "Positive"
    /// Something one is trying to avoid
    case negative = "Negative"
    /// Neither positive or negative.
    case neutral = "Neutral"
}

public enum GoalResult: Codable, Equatable {
    /// A goal with levels of completion
    case completion(steps: GoalResult.Steps, result: Int)
    /// A goal with a whole number count
    case count(goals: SortedSet<Int>, result: Int)
    /// A goal with a decimal count
    case number(goals: SortedSet<Double>, result: Double)
    /// A routine to follow
    case routine(routine: Key, result: Key)
    
    public static func == (lhs: GoalResult, rhs: GoalResult) -> Bool {
        switch (lhs, rhs) {
        case (.completion(let ls, let lr), .completion(let rs, let rr)):
            return ls == rs && lr == rr
        case (.count(let lg, let lr), .count(let rg, let rr)):
            return lg == rg && lr == rr
        case (.number(let lg, let lr), .number(let rg, let rr)):
            return lg == rg && lr == rr
        case (.routine(let lr, let lrr), .routine(let rr, let rrr)):
            return lr == rr && lrr == rrr
        default:
            return false
        }
    }
    
    public enum Config: Codable, Equatable {
        case completion(steps: GoalResult.Steps)
        case count(goals: SortedSet<Int>)
        case number(goals: SortedSet<Double>)
        case routine(routine: Key)
        
        public static func == (lhs: GoalResult.Config, rhs: GoalResult.Config) -> Bool {
            switch (lhs, rhs) {
            case (.completion(let ls), .completion(let rs)):
                return ls == rs
            case (.count(let lg), .count(let rg)):
                return lg == rg
            case (.number(let lg), .number(let rg)):
                return lg == rg
            case (.routine(let lroutine), .routine(let rroutine)):
                return lroutine == rroutine
            default:                return false
            }
        }
        
        public enum Variant: String, Equatable, CaseIterable {
            case completion = "Completion"
            case count = "Count"
            case number = "Number"
            case routine = "Routine"
        }
        
        public var variant: Self.Variant {
            switch self {
            case .completion(_): .completion
            case .count(_): .count
            case .number(_): .number
            case .routine(_): .routine
            }
        }
        
        public var empty: GoalResult {
            switch self {
            case .completion(let steps): return .completion(steps: steps, result: 0)
            case .count(let goals): return .count(goals: goals, result: 0)
            case .number(let goals): return .number(goals: goals, result: 0)
            case .routine(let routine): return .routine(routine: routine, result: .null)
            }
        }
        
        public var title: String {
            switch self {
            case .completion(_): return "Completion"
            case .count(_): return "Count"
            case .number(_): return "Number"
            case .routine(_): return "Routine"
            }
        }
        
        public var values: String {
            switch self {
            case .completion(let steps): return "Steps: \(steps.count)"
            case .count(let goals): return "Goals: \(goals.values)"
            case .number(let goals): return "Goals: \(goals.values)"
            case .routine(let routine): return "Routine"
            }
        }
        
        public var label: String {
            "\(title)\n\(values)"
        }
        
        /// Returns the step count of any completion goal result. Returns nil if not a completion goal.
        public var stepCount: Int? {
            switch self {
            case .completion(let steps): steps.count
            case .count(_), .number(_), .routine(_): nil
            }
        }
        
        /// Returns the step count of any completion goal result. Returns nil if not a completion goal.
        public var stepVariant: GoalResult.Steps.Variant? {
            switch self {
            case .completion(let steps): steps.variant
            case .count(_), .number(_), .routine(_): nil
            }
        }
        
        /// Returns the count goals of any count goal result. Returns nil if not a completion goal.
        public var countGoals: [Int]? {
            switch self {
            case .count(let goals): goals.values
            case .completion(_), .number(_), .routine(_): nil
            }
        }
        
        /// Returns the step count of any completion goal result. Returns nil if not a completion goal.
        public var numberGoals: [Double]? {
            switch self {
            case .number(let goals): goals.values
            case .completion(_), .count(_), .routine(_): nil
            }
        }
    }
    
    public var config: GoalResult.Config {
        switch self {
        case .completion(let steps, _): .completion(steps: steps)
        case .count(let goals, _): .count(goals: goals)
        case .number(let goals, _): .number(goals: goals)
        case .routine(let routine, _): .routine(routine: routine)
        }
    }
    
    /// Steps determine the 'points' rewarded for a completion goal, for users track history
    ///  and award points proportional to completion effort
    public enum Steps: Codable, Equatable {
        /// A linear point progression
        case linear(steps: Int)
        /// A point progression following the fibbonacci sequence
        case fibbonaci(steps: Int)
        
        /// The points for a resulting number of steps completed
        public func pointsFor(completed: Int) -> Int {
            switch self {
            case .linear(let steps): max(steps, completed)
            case .fibbonaci(let steps): max(steps, completed) // should be fibb(max(steps, completed))
            }
        }
        
        public var count: Int {
            switch self {
            case .linear(let steps): steps
            case .fibbonaci(let steps): steps
            }
        }
        
        public enum Variant: String, Equatable, CaseIterable {
            case linear = "Linear"
            case fibbonaci = "Fibbonaci"
        }
        
        public var variant: Self.Variant {
            switch self {
            case .linear(_): .linear
            case .fibbonaci(_): .fibbonaci
            }
        }
    }
    
    /// 'Points' are how goals are tracked in history and for term goals
    public var points: Double {
        switch self {
        case .completion(let steps, let result): Double(steps.pointsFor(completed: result))
        case .count(_, let result): Double(result)
        case .number(_, let result): result
        case .routine(_, _): 0
        }
    }
}

