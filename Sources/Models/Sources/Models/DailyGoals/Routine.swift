//
//  Routine.swift
//  Models
//
//  Created by Kevin Kelly on 2/24/25.
//

import Foundation
import Domain

public final class Routine: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The steps that are apart of this routine
    public let stepIds: [Key]
    
    /// The name of the routine
    public let label: String
    /// Optional description of the routine
    public let description: String?
    
    public static func == (lhs: Routine, rhs: Routine) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , stepIds: [Key]
        , label: String
        , description: String?
    ) {
        self.id = id
        self.stepIds = stepIds
        self.label = label
        self.description = description
    }
    
    public var asEmptyResult: RoutineResult {
        RoutineResult.init(
            id: .new()
            , routineId: self.id
            , stepResultIds: []
            , label: self.label
            , date: .today
            , recorded: .now
        )
    }
}

public final class RoutineStep: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine this step is a part of.
    public let routineId: Key
    
    /// The name of the routine step
    public let label: String
    /// Optional description of the routine step
    public let description: String?
    /// The place of the step in the order of the routine
    public let index: Int
    /// The type of timer used in this step
    public let timer: RoutineStepTimer
    
    public static func == (lhs: RoutineStep, rhs: RoutineStep) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , routineId: Key
        , label: String
        , description: String?
        , index: Int
        , timer: RoutineStepTimer
    ) {
        self.id = id
        self.routineId = routineId
        self.label = label
        self.description = description
        self.index = index
        self.timer = timer
    }
}

public enum RoutineStepTimer: Codable, Equatable  {
    case up
    case down
}

public final class RoutineResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine that generated this result.
    public let routineId: Key
    /// The steps that are apart of this routine result
    public let stepResultIds: [Key]
    
    /// The name of the routine result
    public let label: String
    /// The date the routine was performed
    public let date: Date
    /// the time the routine result was recorded
    public let recorded: Date
    
    public static func == (lhs: RoutineResult, rhs: RoutineResult) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , routineId: Key
        , stepResultIds: [Key]
        , label: String
        , date: Date
        , recorded: Date
    ) {
        self.id = id
        self.routineId = routineId
        self.stepResultIds = stepResultIds
        self.label = label
        self.date = date
        self.recorded = recorded
    }
}

public final class RoutineStepResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine step this result is from.
    public let routineStepId: Key
    /// The routine result this step is a part of.
    public let routineResultId: Key
    
    /// The name of the routine step result
    public let label: String
    /// the time the routine result was recorded
    public let recorded: Date
    /// The place of the step in the order of the routine
    public let index: Int
    
    public static func == (lhs: RoutineStepResult, rhs: RoutineStepResult) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(
        id: Key
        , routineStepId: Key
        , routineResultId: Key
        , label: String
        , recorded: Date
        , index: Int
    ) {
        self.id = id
        self.routineStepId = routineStepId
        self.routineResultId = routineResultId
        self.label = label
        self.recorded = recorded
        self.index = index
    }
}
