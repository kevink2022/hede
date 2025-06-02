//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/2/24.
//

import Foundation
import Domain

/// The different kinds of tasks that can show up on the timeline or calendar.
public enum TaskTime: Codable, Equatable {
    /// Something that occurs a certain time frame.
    case appointment(start: Date, end: Date)
    /// Something that needs to be done *before* a certain time.
    case deadline(Date)
    /// Something that needs to be done *after* a certain time, with no further deadline.
    case task(Date)
    /// Something that requires no action from the user.
    case reminder(Date)
}

extension TaskTime {
    /// Start time independant TaskTime
    public enum Pattern: Codable, Equatable {
        case appointment(TimeDuration)
        case deadline
        case task
        case reminder
    }
    
    public var pattern: TaskTime.Pattern {
        switch self {
        case .appointment(_, _): .appointment(.weeks(1))
        case .deadline(_): .deadline
        case .task(_): .task
        case .reminder(_): .reminder
        }
    }
    
    /// Valueless TaskTime
    public enum Case: CaseIterable, Equatable {
        case appointment
        case deadline
        case task
        case reminder
    }
    
    public var taskCase: TaskTime.Case {
        switch self {
        case .appointment(_, _): .appointment
        case .deadline(_): .deadline
        case .task(_): .task
        case .reminder(_): .reminder
        }
    }
    
    /// The start time of a task.
    public var start: Date {
        switch self {
        case .appointment(let start, _): return start
        case .deadline(let date): return date
        case .task(let date): return date
        case .reminder(let date): return date
        }
    }
    
    public var end: Date? {
        switch self {
        case .appointment(_, let end): return end
        case .deadline(_), .task(_), .reminder(_): return nil
        }
    }
    
    public func new(at newStart: Date) -> TaskTime {
        switch self {
        case .appointment(let start, let end):
            let duration = end.timeIntervalSince(start)
            let newEnd = newStart.addingTimeInterval(duration)
            return .appointment(start: newStart, end: newEnd)
            
        case .deadline(_): return .deadline(newStart)
        case .task(_): return .task(newStart)
        case .reminder(_): return .reminder(newStart)
        }
    }
    
    public static func new(_ type: TaskTime.Pattern, from start: Date) -> TaskTime {
        switch type {
        case .appointment(let timeDuration):
            let end = start.adding(timeDuration) ?? start.addingTimeInterval(60*60)
            return .appointment(start: start, end: end)
        
        case .deadline: return .deadline(start)
        case .task: return .task(start)
        case .reminder: return .reminder(start)
        }
    }
    
    public static func new(_ taskCase: TaskTime.Case, from start: Date, to end: Date? = nil) -> TaskTime? {
        
        switch taskCase {
        case .appointment: 
            guard let end = end else { return nil }
            return .appointment(start: start, end: end)
        case .deadline:  return .deadline(start)
        case .task: return .task(start)
        case .reminder: return .reminder(start)
        }
    }
}
