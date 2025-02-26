////
////  Learning2.swift
////  Models
////
////  Created by Kevin Kelly on 2/12/25.
////
//
//import Foundation
//
//public final class LearningSource: TaskSource {
//    public typealias AssociatedTask = LearningTask
//    
//    public let id: Key
//    public let label: String
//    public let description: String?
//    public let category: Key?
//    public let pauses: [Key]?
//    public let deactivated: Date?
//    public let repetitionSchedule: [TimeDuration]
//    
//    
//    public static func create(
//        label: String
//        , description: String?
//        , taskTime: TaskTime
//        , repetitionSchedule: [TimeDuration]
//        , category: Key?
//        , pauses: [Key]?
//    ) -> (source: LearningSource, initialTask: LearningTask) {
//        
//        let sourceKey = Key.new()
//        let taskKey = Key.new()
//        let source = LearningSource(
//            id: sourceKey
//            , label: label
//            , description: description
//            , category: category
//            , pauses: pauses
//            , repetitionSchedule: repetitionSchedule
//            , deactivated: nil
//        )
//        let initialTask = LearningTask(
//            id: taskKey
//            , source: sourceKey
//            , label: label
//            , scheduled: taskTime
//            , completed: nil
//            , repetitionIndex: 0
//        )
//        return (source, initialTask)
//    }
//    
//    
//    public func generateNewTask(from completedTask: LearningTask) -> LearningTask? {
//        guard completedTask.isCompleted, let comp = completedTask.completed else { return nil }
//        
//        let index = completedTask.repetitionIndex
//        if index >= repetitionSchedule.count { return nil }
//        
//        guard let newStart = comp.adding(repetitionSchedule[index]) else { return nil }
//        
//        let newTime = completedTask.scheduled.new(from: newStart)
//        return LearningTask(
//            id: Key.new()
//            , source: self.id
//            , label: self.label
//            , scheduled: newTime
//            , completed: nil
//            , repetitionIndex: index + 1
//        )
//    }
//    
//    
//    public func deactivate(date: Date?) -> LearningSource {
//        guard self.active else { return self }
//        return LearningSource(source: self, deactivation: date ?? Date.now)
//    }
//    
//    
//    public func activate() -> LearningSource {
//        guard !self.active else { return self }
//        return LearningSource(source: self, deactivation: .null)
//    }
//    
//    
//    public static func == (lhs: LearningSource, rhs: LearningSource) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.label == rhs.label &&
//        lhs.description == rhs.description &&
//        lhs.deactivated == rhs.deactivated &&
//        lhs.repetitionSchedule == rhs.repetitionSchedule &&
//        lhs.category == rhs.category &&
//        lhs.pauses == rhs.pauses
//    }
//    
//    
//    internal init(
//        id: Key
//        , label: String
//        , description: String?
//        , category: Key?
//        , pauses: [Key]?
//        , repetitionSchedule: [TimeDuration]
//        , deactivated: Date?
//    ) {
//        self.id = id
//        self.label = label
//        self.description = description
//        self.category = category
//        self.pauses = pauses
//        self.repetitionSchedule = repetitionSchedule
//        self.deactivated = deactivated
//    }
//    
//    
//    private convenience init(source: LearningSource, deactivation: Date) {
//        self.init(
//            id: source.id
//            , label: source.label
//            , description: source.description
//            , category: source.category
//            , pauses: source.pauses
//            , repetitionSchedule: source.repetitionSchedule
//            , deactivated: deactivation.nulled()
//        )
//    }
//    
//    
//    public var code: TaskSourceCode { .learning(self) }
//}
//
//public final class LearningTask: UserTask {
//    public let id: Key
//    public let source: Key
//    public let label: String
//    public let scheduled: TaskTime
//    public let completed: Date?
//    public let repetitionIndex: Int
//    
//    public func complete(date: Date?) -> LearningTask {
//        LearningTask(
//            id: self.id
//            , source: self.source
//            , label: self.label
//            , scheduled: self.scheduled
//            , completed: date ?? Date.now
//            , repetitionIndex: self.repetitionIndex
//        )
//    }
//        
//    
//    public func edit(
//        label: String? = nil
//        , scheduled: TaskTime? = nil
//        , completed: Date? = nil
//        , repetitionIndex: Int? = nil
//    ) -> LearningTask {
//        LearningTask(
//            id: self.id
//            , source: self.source
//            , label: label ?? self.label
//            , scheduled: scheduled ?? self.scheduled
//            , completed: completed.null(or: self.completed)
//            , repetitionIndex: repetitionIndex ?? self.repetitionIndex
//        )
//    }
//    
//    
//    public static func == (lhs: LearningTask, rhs: LearningTask) -> Bool {
//        lhs.id == rhs.id &&
//        lhs.label == rhs.label &&
//        lhs.scheduled == rhs.scheduled &&
//        lhs.completed == rhs.completed &&
//        lhs.repetitionIndex == rhs.repetitionIndex
//    }
//    
//    
//    internal init(
//        id: Key
//        , source: Key
//        , label: String
//        , scheduled: TaskTime
//        , completed: Date?
//        , repetitionIndex: Int
//    ) {
//        self.id = id
//        self.source = source
//        self.label = label
//        self.scheduled = scheduled
//        self.completed = completed
//        self.repetitionIndex = repetitionIndex
//    }
//    
//    
//    public var code: TaskCode { .learning(self) }
//}
//
