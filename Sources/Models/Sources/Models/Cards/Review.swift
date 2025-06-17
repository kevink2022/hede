//
//  Review.swift
//  Models
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Domain


public final class FlashcardReview: Identifiable, Codable {
    public var id: Key { task.id }
    public var cardId: Flashcard.ID { task.schedulerId }

    public let task: HedeTask
    
    internal init(task: HedeTask
    ) {
        self.task = task
    }
}

// MARK: - Variables

extension FlashcardReview {
    public var scheduled: TaskTime { task.scheduled }
    public var completed: Date? { task.completed }
    public var sortDate: Date { task.completed ?? task.scheduled.start }
    public var isComplete: Bool { completed != nil }
}

// MARK: - Methods

extension FlashcardReview {
    public func complete(
        at date: Date?
        , review: AnySpacedRepetitionContext? = nil
    ) -> FlashcardReview {
        return FlashcardReview(task: self.task.complete(
            at: date
            , review: review)
        )
    }
}


// MARK: - Conformance

extension FlashcardReview: Equatable {
    public static func == (lhs: FlashcardReview, rhs: FlashcardReview) -> Bool {
        lhs.task == rhs.task
    }
}

extension FlashcardReview: Nullable {
    public static let null = FlashcardReview(task: .null)
}

extension FlashcardReview: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
