//
//  File.swift
//  
//
//  Created by Kevin Kelly on 8/30/24.
//

import Foundation

/// A reccuring task that scehdule a new task when completed
public final class ReccuringSource: TaskSourceCodable {
    public typealias AssociatedTask = ReccuringTask
    public let id: Key
    public let label: String
    public let description: String?
    public let category: Key?
    public let pauses: [Key]?
    public var deactivated: Date?
    
    public func generateNewTask(from completedTask: ReccuringTask) -> ReccuringTask? {
        guard completedTask.isCompleted else { return nil }
        guard let baseStart = type.baseTime(from: completedTask) else { return nil }
        guard let newStart = baseStart.adding(spacing) else { return nil }
        let newTime = completedTask.scheduled.new(from: newStart)
        
        return ReccuringTask(
            completedTask: completedTask
            , newTime: newTime
        )
    }
    
    /// The way a new task is generated, either from when the previous task started or was completed.
    public let type: ReccuranceType
    
    /// The duration of time between recurrances of the task.
    public let spacing: TimeDuration
    
    /// Public method of creating a new Reccuring Source, returning both the new source and the inital task to start the task loop.
    public static func create(
        label: String
        , description: String?
        , taskType: TaskTime.TimeType
        , recurranceType: ReccuranceType
        , spacing: TimeDuration
        , lastCompleted: Date?
        , category: Key?
        , pauses: [Key]?
    ) -> (source: ReccuringSource, initialTask: ReccuringTask) {
        
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
        
        let initialTask = ReccuringTask(
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
        , type: ReccuranceType?
        , spacing: TimeDuration?
    ) -> ReccuringSource {
        let newDescription: String? = {
            if description == "" { return nil }
            else { return description ?? self.description}
        }()
        
        let newCategory: Key? = {
            if category == .null { return nil }
            else { return category ?? self.category }
        }()
        
        let newPauses: [Key]? = {
            if pauses == [] { return nil }
            else { return pauses ?? self.pauses}
        }()
        
        return ReccuringSource(
            id: self.id
            , label: label ?? self.label
            , description: newDescription
            , category: newCategory
            , pauses: newPauses
            , type: type ?? self.type
            , spacing: spacing ?? self.spacing
            , deactivated: self.deactivated
        )
    }
    
    public func deactivate(date: Date?) -> ReccuringSource {
        guard self.active else { return self }
        return ReccuringSource(source: self, deactivation: date ?? Date.now)
    }
    
    public func activate() -> ReccuringSource {
        guard !self.active else { return self }
        return ReccuringSource(source: self, deactivation: .null)
    }
    
    public static func == (lhs: ReccuringSource, rhs: ReccuringSource) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed (except keys)
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.deactivated == rhs.deactivated
        && lhs.type == rhs.type
        && lhs.spacing == rhs.spacing
    }
    
    internal init(
        id: Key
        , label: String
        , description: String?
        , category: Key?
        , pauses: [Key]?
        , type: ReccuranceType
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
        source: ReccuringSource
        , deactivation: Date
    ) {
        let newDate = deactivation == .null ? nil : deactivation
        
        self.init(
            id: source.id
            , label: source.label
            , description: source.description
            , category: source.category
            , pauses: source.pauses
            , type: source.type
            , spacing: source.spacing
            , deactivated: newDate
        )
    }
    
    internal var code: TaskSourceCode { .recurring(self) }
}

/// The way a new task is generated, either from when the previous task started or was completed.
public enum ReccuranceType: Codable {
    /// Base the next task's date on the time the current task was completed
    case fromComplete
    /// Base the next task's date on the time the current task was scheduled
    case fromScheduled
}

extension ReccuranceType {
    
    internal func baseTime(from task: ReccuringTask) -> Date? {
        switch self {
        case .fromComplete: task.completed
        case .fromScheduled: task.scheduled.start
        }
    }
}


public final class ReccuringTask: TaskCodable {
    public let id: Key
    public let source: Key
    public let label: String
    public let scheduled: TaskTime
    public let completed: Date?
    
    public func complete(date: Date?) -> ReccuringTask {
        return ReccuringTask(
            id: self.id
            , source: self.source
            , label: self.label
            , scheduled: self.scheduled
            , completed: date ?? Date.now
        )
    }
    
    public func edit(
        label: String? = nil
        , scheduled: TaskTime? = nil
        , completed: Date? = nil
    ) -> ReccuringTask {
        
        let newCompleted: Date? = {
            if completed == .null { return nil }
            else { return completed ?? self.completed }
        }()
        
        return ReccuringTask(
            id: self.id
            , source: self.source
            , label: label ?? self.label
            , scheduled: scheduled ?? self.scheduled
            , completed: newCompleted
        )
    }
    
    public static func == (lhs: ReccuringTask, rhs: ReccuringTask) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed (except keys)
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
    
    /// Schedule another instance of the task at a new time.
    internal convenience init(
        completedTask: ReccuringTask
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
    
    internal var code: TaskCode { .recurring(self) }
}
