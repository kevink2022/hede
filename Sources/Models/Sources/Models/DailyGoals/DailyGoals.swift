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
    public let type: GoalResult.Config
    /// Whether the goal is a positive behavior (more is better) or negative
    public let positive: Bool
    /// The days of the week this goal is active on
    public let days: [Weekday]
    /// Whether the goal is acitvely being tracked
    public let active: Bool
    
    public static func == (lhs: DailyGoal, rhs: DailyGoal) -> Bool {
        lhs.id == rhs.id
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.type == rhs.type
        && lhs.positive == rhs.positive
        && lhs.days == rhs.days
        && lhs.active == rhs.active
    }
}

/// A daily goal result is an instance of a completed goal
public final class DailyGoalResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The ID of the goal itself
    public let parent: Key
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
}


public enum GoalResult: Codable, Equatable {
    /// A goal with levels of completion
    case completion(steps: GoalResult.Steps, result: Int)
    /// A goal with a whole number count
    case count(goals: SortedSet<Int>, result: Int)
    /// A goal with a decimal count
    case number(goals: SortedSet<Double>, result: Double)
    /// A routine to follow
    case routine(routine: Routine, result: RoutineResult)
    
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
        case routine(routine: Routine)
        
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
            default:
                return false
            }
        }
    }
    
    var config: GoalResult.Config {
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
        func pointsFor(completed: Int) -> Int {
            switch self {
            case .linear(let steps): max(steps, completed)
            case .fibbonaci(let steps): max(steps, completed) // should be fibb(max(steps, completed))
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

/// A day result if a collection of daily goal results for a sepicifc fay
public final class DayResult: Codable, Identifiable {
    public let date: Date
    public let goals: [DailyGoal]
}
