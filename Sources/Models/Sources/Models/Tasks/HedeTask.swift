//
//  HedeTask.swift
//  Models
//
//  Created by Kevin Kelly on 5/29/25.
//

import Domain
import Foundation


/// The way a new task is generated, either from when the previous task started or was completed.
public enum RecurrencePattern: Codable, CaseIterable, Equatable {
    /// Base the next task's date on the time the current task was completed
    case fromComplete
    /// Base the next task's date on the time the current task was scheduled
    case fromScheduled
}

public final class HedeTask: Codable, Identifiable {

    public let id: Key
    public let schedulerId: Key
    public let label: String
    
    public let scheduled: TaskTime
    public let completed: Date?
    public let state: AnySpacedRepetitionContext?
    public let review: AnySpacedRepetitionContext?
    
    internal init(
        id: Key
        , schedulerId: Key
        , label: String
        , scheduled: TaskTime
        , completed: Date?
        , state: AnySpacedRepetitionContext?
        , review: AnySpacedRepetitionContext?
    ) {
        self.id = id
        self.schedulerId = schedulerId
        self.label = label
        self.scheduled = scheduled
        self.completed = completed
        self.state = state
        self.review = review
    }
}

// MARK: - Variables

extension HedeTask {
    public var sortDate: Date { self.completed ?? self.scheduled.start }
    public var isComplete: Bool { completed != nil }
}

// MARK: - Methods

extension HedeTask {
    
    public func complete(
        at date: Date?
        , review: AnySpacedRepetitionContext? = nil
    ) -> HedeTask {
        .init(
            id: id
            , schedulerId: schedulerId
            , label: label
            , scheduled: scheduled
            , completed: date ?? .now
            , state: state
            , review: review
        )
    }
    
    public func unComplete() -> HedeTask {
        .init(
            id: id
            , schedulerId: schedulerId
            , label: label
            , scheduled: scheduled
            , completed: nil
            , state: state
            , review: nil
        )
    }
    
    public func reschedule(at time: TaskTime) -> HedeTask {
        .init(
            id: id
            , schedulerId: schedulerId
            , label: label
            , scheduled: time
            , completed: completed
            , state: state
            , review: review
        )
    }
    
    public func edit(
        label: String?
    ) -> HedeTask {
        .init(
            id: id
            , schedulerId: schedulerId
            , label: label ?? self.label
            , scheduled: scheduled
            , completed: completed
            , state: state
            , review: review
        )
    }
}

// MARK: - Conformance

extension HedeTask: Equatable {
    public static func == (lhs: HedeTask, rhs: HedeTask) -> Bool {
        lhs.id == rhs.id
        && lhs.schedulerId == rhs.schedulerId
        && lhs.label == rhs.label
        && lhs.scheduled == rhs.scheduled
        && lhs.completed == rhs.completed
        && lhs.state == rhs.state
        && lhs.review == rhs.review
    }
}

extension HedeTask: Nullable {
    public static let null = HedeTask(
        id: .new()
        , schedulerId: HedeScheduler.null.id
        , label: "NULL TASK"
        , scheduled: .task(.now)
        , completed: nil
        , state: nil
        , review: nil
    )
}

extension HedeTask: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
