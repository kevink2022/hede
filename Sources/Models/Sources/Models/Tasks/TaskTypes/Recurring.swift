//
//  File.swift
//  
//
//  Created by Kevin Kelly on 8/30/24.
//

import Foundation
import Domain

/// A reccuring task that scehdule a new task when completed
public final class RecurringSource: TaskSource {
    public typealias AssociatedTask = RecurringTask
    public let id: Key
    public let label: String
    public let description: String?
    public let category: Key?
    public let pauses: [Key]?
    public var deactivated: Date?
    public var code: TaskSourceCode { .recurring(self) }
    
    /// The way a new task is generated, either from when the previous task started or was completed.
    public let type: RecurrenceType
    
    /// The duration of time between recurrances of the task.
    public let spacing: TimeDuration
    
    public func generateNewTask(from completedTask: RecurringTask) -> RecurringTask? {
        guard completedTask.isCompleted else { return nil }
        guard let baseStart = type.baseTime(from: completedTask) else { return nil }
        guard let newStart = baseStart.adding(spacing) else { return nil }
        let newTime = completedTask.scheduled.new(from: newStart)
        
        return RecurringTask(
            completedTask: completedTask
            , newTime: newTime
        )
    }
   
    /// Public method of creating a new Reccuring Source, returning both the new source and the inital task to start the task loop.
    public static func create(
        label: String
        , description: String?
        , taskType: TaskTime.Pattern
        , recurranceType: RecurrenceType
        , spacing: TimeDuration
        , lastCompleted: Date?
        , category: Key?
        , pauses: [Key]?
    ) -> (source: RecurringSource, initialTask: RecurringTask) {
        
        let sourceKey = Key.new()
        
        let source = self.init(
            id: sourceKey
            , label: label
            , description: description
            , category: category
            , pauses: pauses
            , type: recurranceType
            , spacing: spacing
            , deactivated: nil
        )
        
        let initialDate = {
            if let lastCompleted = lastCompleted {
                return lastCompleted.adding(spacing) ?? Date.now
            } else {
                return Date.now
            }
        }()
        
        let initialTask = RecurringTask(
            id: Key.new()
            , source: sourceKey
            , label: label
            , scheduled: TaskTime.new(taskType, from: initialDate)
            , completed: nil
        )
        
        return (source, initialTask)
    }
    
    /// Change a reccurring source.
    public func edit(
        label: String?
        , description: String?
        , category: Key?
        , pauses: [Key]?
        , taskType: TaskTime.Pattern?
        , type: RecurrenceType?
        , spacing: TimeDuration?
        , lastTask: RecurringTask
    ) -> (source: RecurringSource, newTask: RecurringTask) {
        
        let newDueDate: Date = {
            guard
                let spacing = spacing
                , spacing != self.spacing
            else { return nil }
            
            return lastTask.scheduled.start
                .subtracting(self.spacing)?
                .adding(spacing)
            
        }() ?? lastTask.scheduled.start
        
        let newTask = lastTask.edit(
            label: label
            , scheduled: TaskTime.new(taskType ?? lastTask.scheduled.pattern, from: newDueDate)
            , completed: lastTask.completed
        )
        
        let newSource = RecurringSource(
            id: self.id
            , label: label ?? self.label
            , description: description.null(or: self.description)
            , category: category.null(or: self.category)
            , pauses: pauses.null(or: self.pauses)
            , type: type ?? self.type
            , spacing: spacing ?? self.spacing
            , deactivated: self.deactivated
        )
        
        return (newSource, newTask)
    }
    
    public func deactivate(date: Date?) -> RecurringSource {
        guard self.active else { return self }
        return RecurringSource(source: self, deactivation: date ?? Date.now)
    }
    
    public func activate() -> RecurringSource {
        guard !self.active else { return self }
        return RecurringSource(source: self, deactivation: .null)
    }
    
    public static func == (lhs: RecurringSource, rhs: RecurringSource) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.deactivated == rhs.deactivated
        && lhs.type == rhs.type
        && lhs.spacing == rhs.spacing
        && lhs.category == rhs.category
        && lhs.pauses == rhs.pauses
    }
    
    internal init(
        id: Key
        , label: String
        , description: String?
        , category: Key?
        , pauses: [Key]?
        , type: RecurrenceType
        , spacing: TimeDuration
        , deactivated: Date?
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.category = category
        self.pauses = pauses
        self.type = type
        self.spacing = spacing
        self.deactivated = deactivated
    }
    
    private convenience init(
        source: RecurringSource
        , deactivation: Date
    ) {
        self.init(
            id: source.id
            , label: source.label
            , description: source.description
            , category: source.category
            , pauses: source.pauses
            , type: source.type
            , spacing: source.spacing
            , deactivated: deactivation.nulled()
        )
    }
    
}

/// The way a new task is generated, either from when the previous task started or was completed.
public enum RecurrenceType: Codable, CaseIterable, Equatable {
    /// Base the next task's date on the time the current task was completed
    case fromComplete
    /// Base the next task's date on the time the current task was scheduled
    case fromScheduled
}

extension RecurrenceType {
    
    internal func baseTime(from task: RecurringTask) -> Date? {
        switch self {
        case .fromComplete: task.completed
        case .fromScheduled: task.scheduled.start
        }
    }
}


public final class RecurringTask: UserTask {
    public let id: Key
    public let source: Key
    public let label: String
    public let scheduled: TaskTime
    public let completed: Date?
    public var code: TaskCode { .recurring(self) }
    
    public func complete(date: Date?) -> RecurringTask {
        return RecurringTask(
            id: self.id
            , source: self.source
            , label: self.label
            , scheduled: self.scheduled
            , completed: date ?? Date.now
        )
    }
    
    public static func == (lhs: RecurringTask, rhs: RecurringTask) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed
        && lhs.label == rhs.label
        && lhs.scheduled == rhs.scheduled
        && lhs.completed == rhs.completed
    }
    
    internal init(
        id: Key
        , source: Key
        , label: String
        , scheduled: TaskTime
        , completed: Date?
    ) {
        self.id = id
        self.source = source
        self.label = label
        self.scheduled = scheduled
        self.completed = completed
    }
    
    internal func edit(
        label: String? = nil
        , scheduled: TaskTime? = nil
        , completed: Date? = nil
    ) -> RecurringTask {
        
        let newCompleted: Date? = completed.null(or: self.completed)
                
        return RecurringTask(
            id: self.id
            , source: self.source
            , label: label ?? self.label
            , scheduled: scheduled ?? self.scheduled
            , completed: newCompleted
        )
    }
    
    /// Schedule another instance of the task at a new time.
    internal convenience init(
        completedTask: RecurringTask
        , newTime: TaskTime
    ) {
        self.init(
            id: Key.new()
            , source: completedTask.source
            , label: completedTask.label
            , scheduled: newTime
            , completed: nil
        )
    }
}
