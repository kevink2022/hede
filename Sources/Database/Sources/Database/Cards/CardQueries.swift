//
//  CardQueries.swift
//  Database
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Models
import Assemblages

extension TaskRepository {
    public var parentDecks: [FlashcardDeck] { basis.basis.deckSet[nil]?.values ?? [FlashcardDeck]() }
    public func reviews(_ ids: [FlashcardReview.ID]) -> [FlashcardReview] { ids.compactMap { basis.cardReviewMap[$0] } }
}

fileprivate let repo = Repository.system.tasks

extension Flashcard {
    public var deck: FlashcardDeck { repo.basis.deckMap[deckId] ?? .null }
    public var reviews: [FlashcardReview] { repo.basis.basis.cardReviewSet.index[id]?.values ?? [] }
    public var nextReview: FlashcardReview { reviews.last ?? .null }
}

extension FlashcardReview {
    public var card: Flashcard { repo.basis.cardMap[cardId] ?? .null }
    public var deck: FlashcardDeck { card.deck }
}

extension FlashcardDeck {
    public var childDecks: [FlashcardDeck] { repo.basis.basis.deckSet[id]?.values ?? [FlashcardDeck]() }
    public var parent: FlashcardDeck? { repo.basis.deckMap[parentDeckId] }
    
    public var cards: [Flashcard] { repo.basis.basis.cardSet[id]?.values ?? [] }
    
    public var allCards: [Flashcard] {
        let cards = repo.basis.basis.cardSet[id] ?? []
        return childDecks.reduce(into: cards) { cards, deck in
            cards.insert(deck.allCards)
        }.values
    }
    
    public var deckPath: String {
        var path = "\(label)"
        var deck = self
        while let parent = deck.parent {
            path = ("\(parent.label) > ") + path
            deck = parent
        }
        return path
    }
    
    public var newReviewLimit: Int { 15 }
    public var nextReviews: [FlashcardReview] { allCards.compactMap(\.nextReview) }
    public var allOpenReviews: [FlashcardReview] { nextReviews.filter { $0.scheduled.start < .now } }
    public var newReviews: [FlashcardReview] { allOpenReviews.filter { $0.task.state == nil } }
    public var repeatReviews: [FlashcardReview] { allOpenReviews.filter { $0.task.state != nil } }
    public var openReviews: [FlashcardReview] { repeatReviews + newReviews.prefix(max(0, newReviewLimit - newCompletedToday)) }

    public var newCompletedToday: Int { allCards
        .compactMap { $0.reviews.first }
        .filter { $0.completed?.startOfDay == .now.startOfDay }
        .count
    }
    
}

extension Array where Element == FlashcardDeck {
    public var openReviews: [FlashcardReview] { self.map { $0.openReviews }.reduce([], +) }
}
