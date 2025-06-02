//
//  HedeScheduler.swift
//  Models
//
//  Created by Kevin Kelly on 5/30/25.
//

import Foundation
import Domain

public final class HedeScheduler: Codable, Identifiable/*, Equatable, Hashable*/ {
    
    public let id: Key
    public let label: String
    public let description: String?
    public let active: Bool

    public let tagIds: [HedeTag.ID]
    /// The algorithm to determine when the next task will be scheduled. If `nil`, it will not be reschudeled.
    public let algorithm: AnySpacedRepetition?
    public let recurrencePattern: RecurrencePattern
    
    internal init(
        id: Key
        , label: String
        , description: String?
        , tagIds: [HedeTag.ID]
        , active: Bool
        , algorithm: AnySpacedRepetition?
        , recurrencePattern: RecurrencePattern
    ) {
        self.id = id
        self.label = label
        self.description = description
        self.tagIds = tagIds
        self.active = active
        self.algorithm = algorithm
        self.recurrencePattern = recurrencePattern
    }
}

// MARK: - Methods

extension HedeScheduler {
    
    public static func create(
        label: String
        , description: String?
        , tags: [HedeTag]
        , algorithm: AnySpacedRepetition?
        , recurrencePattern: RecurrencePattern
        , startOn: TaskTime
    ) -> (scheduler: HedeScheduler, task: HedeTask) {
        
        let scheduler = HedeScheduler(
            id: .new()
            , label: label
            , description: description
            , tagIds: tags.map { $0.id }
            , active: true
            , algorithm: algorithm
            , recurrencePattern: recurrencePattern
        )
        
        let task = HedeTask(
            id: .new()
            , schedulerId: scheduler.id
            , label: scheduler.label
            , scheduled: startOn
            , completed: nil
            , state: nil
            , review: nil
        )
        
        return (scheduler, task)
    }
    
    public func edit(
        label: String
        , description: String?
        , tags: [HedeTag]
        , algorithm: AnySpacedRepetition?
        , recurrencePattern: RecurrencePattern
        , startOn: TaskTime
        , lastCompletedTask: HedeTask?
    ) -> HedeScheduler {
        .init(
            id: self.id
            , label: label
            , description: description
            , tagIds: tags.map { $0.id }
            , active: true
            , algorithm: algorithm
            , recurrencePattern: recurrencePattern
        )
    }
    
    public func nextTask(from task: HedeTask) -> HedeTask? {
        guard task.isComplete else { return nil }
        
        guard
            let algorithm = self.algorithm
            , let review = task.review
        else { return nil }
        
        // State is nil on initial reviews
        let state = task.state
        
            
        // If the state is mismatched, the algorithm was changed.
        // Review should be correct since it is fresh.
        // Fallback to initial review.
        let result = algorithm.nextReview(state: state, review: review)
            ?? algorithm.nextReview(state: nil, review: review)

        guard let result else { return nil }
        
        return HedeTask(
            id: .new()
            , schedulerId: self.id
            , label: self.label
            , scheduled: task.scheduled.new(at: result.nextReview)
            , completed: nil
            , state: result.newState
            , review: nil
        )
    }
}

// MARK: - Conformance

extension HedeScheduler: Equatable {
    public static func == (lhs: HedeScheduler, rhs: HedeScheduler) -> Bool {
        lhs.id == rhs.id
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.active == rhs.active
        && lhs.tagIds == rhs.tagIds
        && lhs.algorithm == rhs.algorithm
        && lhs.recurrencePattern == rhs.recurrencePattern
    }
}

extension HedeScheduler: Nullable {
    public static let null = HedeScheduler(
        id: .new()
        , label: "NULL SCHEDULER"
        , description: "NULL SCHEDULER DESCRIPTION"
        , tagIds: []
        , active: true
        , algorithm: nil
        , recurrencePattern: .fromComplete
    )
}

extension HedeScheduler: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
