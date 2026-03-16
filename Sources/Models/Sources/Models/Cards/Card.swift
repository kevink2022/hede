//
//  Card.swift
//  Models
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Domain

public final class Flashcard: Identifiable, Codable {
    public var id: Key { scheduler.id }
    public let deckId: FlashcardDeck.ID
    
    public let scheduler: HedeScheduler
    public let front: [CardElement]
    public let back: [CardElement]
    
    internal init(
        deckId: FlashcardDeck.ID
        , scheduler: HedeScheduler
        , front: [CardElement]
        , back: [CardElement]
    ) {
        self.deckId = deckId
        self.scheduler = scheduler
        self.front = front
        self.back = back
    }
}


// MARK: - Variables

extension Flashcard {
    public var label: String { scheduler.label }
}


// MARK: - Methods

extension Flashcard {
    
    public static func create(
        label: String
        , deck: FlashcardDeck
        , front: [CardElement]
        , back: [CardElement]
    ) -> (card: Flashcard, review: FlashcardReview) {
        
        let (scheduler, task) = HedeScheduler.create(
            label: label
            , description: nil
            , tags: []
            , algorithm: AnySpacedRepetition(AnkiFSRS())
            , recurrencePattern: .fromComplete
            , startOn: .task(.now)
        )
        
        let card = Flashcard(
            deckId: deck.id
            , scheduler: scheduler
            , front: front
            , back: back
        )
        
        let review = FlashcardReview(task: task)
        
        return (card, review)
    }
    
    public func nextReview(from review: FlashcardReview) -> FlashcardReview? {
        guard
            review.isComplete
            , let newTask = scheduler.nextTask(from: review.task)
        else { return nil }
        
        return FlashcardReview(task: newTask)
    }
}

// MARK: - Conformance

extension Flashcard: Equatable {
    public static func == (lhs: Flashcard, rhs: Flashcard) -> Bool {
        lhs.scheduler == rhs.scheduler
        && lhs.front == rhs.front
        && lhs.back == rhs.back
    }
}

extension Flashcard: Nullable {
    public static let null = Flashcard(deckId: .null, scheduler: .null, front: [], back: [])
}

extension Flashcard: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
