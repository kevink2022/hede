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
    
    public static func == (lhs: Routine, rhs: Routine) -> Bool {
        lhs.id == rhs.id
    }
}

public final class RoutineStep: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine this step is a part of.
    public let routine: Key
    
    public static func == (lhs: RoutineStep, rhs: RoutineStep) -> Bool {
        lhs.id == rhs.id
    }
}

public final class RoutineResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine that generated this result.
    public let routine: Key
    
    public static func == (lhs: RoutineResult, rhs: RoutineResult) -> Bool {
        lhs.id == rhs.id
    }
}

public final class RoutineStepResult: Codable, Identifiable, Equatable {
    public let id: Key
    
    /// The routine result this step is a part of.
    public let routine: Key
    
    public static func == (lhs: RoutineStepResult, rhs: RoutineStepResult) -> Bool {
        lhs.id == rhs.id
    }
}
