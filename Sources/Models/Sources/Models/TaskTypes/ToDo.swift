//
//  File.swift
//  
//
//  Created by Kevin Kelly on 8/30/24.
//

import Foundation

/// A one off task source that doesn't generate any repeated tasks.
public final class ToDoSource: TaskSourceCodable {
    public typealias AssociatedTask = ToDoTask
    public let id: Key
    public let label: String
    public let description: String?
    public let category: Key?
    public let pauses: [Key]?
    public let deactivated: Date?

    public func generateNewTask(from completedTask: ToDoTask) -> ToDoTask? {
        // Todo's are one off so never generate new ones.
        return nil
    }
    
    /// Only task to be created by this source.
    public let task: Key
    
    public static func create(
        label: String
        , description: String?
        , time: TaskTime
        , category: Key?
        , pauses: [Key]?
    ) -> (source: ToDoSource, initialTask: ToDoTask) {
        
        let sourceKey = Key.new()
        let taskKey = Key.new()
        
        let source = ToDoSource(
            id: sourceKey
            , label: label
            , description: description
            , task: taskKey
            , category: category
            , pauses: pauses
            , deactivated: nil
        )
        
        let initialTask = ToDoTask(
            id: taskKey
            , source: sourceKey
            , label: label
            , scheduled: time
            , completed: nil
        )
        
        return (source, initialTask)
    }
        
    /// Change a todo source.
    public func edit(
        label: String?
        , description: String?
        , category: Key?
        , pauses: [Key]?
    ) -> ToDoSource {
        return ToDoSource(
            id: self.id
            , label: label ?? self.label
            , description: description.null(or: self.description)
            , task: self.task
            , category: category.null(or: self.category)
            , pauses: pauses.null(or: self.pauses)
            , deactivated: self.deactivated
        )
    }
    
    public func deactivate(date: Date?) -> ToDoSource {
        guard self.active else { return self }
        return ToDoSource(source: self, deactivation: date ?? Date.now)
    }
    
    public func activate() -> ToDoSource {
        guard !self.active else { return self }
        return ToDoSource(source: self, deactivation: .null)
    }
    
    public static func == (lhs: ToDoSource, rhs: ToDoSource) -> Bool {
        lhs.id == rhs.id
        // Things that can be changed (except keys)
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.deactivated == rhs.deactivated
    }
    
    internal init(
        id: Key
        , label: String
        , description: String?
        , task: Key
        , category: Key?
        , pauses: [Key]?
        , deactivated: Date?
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.task = task
        self.category = category
        self.pauses = pauses
        self.deactivated = deactivated
    }
    
    private convenience init(
        source: ToDoSource
        , deactivation: Date
    ) {
        self.init(
            id: source.id
            , label: source.label
            , description: source.description
            , task: source.task
            , category: source.category
            , pauses: source.pauses
            , deactivated: deactivation.nulled()
        )
    }
    
    internal var code: TaskSourceCode { .toDo(self) }
}

/// A one off task.
public final class ToDoTask: TaskCodable {
    public let id: Key
    public let source: Key
    public let label: String
    public let scheduled: TaskTime
    public let completed: Date?
    
    public func complete(date: Date?) -> ToDoTask {
        ToDoTask(
            id: self.id
            , source: self.source
            , label: self.label
            , scheduled: self.scheduled
            , completed: date ?? Date.now
        )
    }
    
    public func edit(
        label: String?
        , scheduled: TaskTime?
        , completed: Date?
    ) -> ToDoTask {
        return ToDoTask(
            id: self.id
            , source: self.source
            , label: label ?? self.label
            , scheduled: scheduled ?? self.scheduled
            , completed: completed.null(or: self.completed)
        )
    }
    
    public static func == (lhs: ToDoTask, rhs: ToDoTask) -> Bool {
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
    
    internal var code: TaskCode { .toDo(self) }
}

