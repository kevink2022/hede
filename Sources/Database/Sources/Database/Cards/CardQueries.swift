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
}

fileprivate let repo = Repository.system.tasks

extension Flashcard {
    var deck: FlashcardDeck { repo.basis.deckMap[deckId] ?? .null }
    var reviews: [FlashcardReview] { repo.basis.basis.cardReviewSet.index[id]?.values ?? [] }
    var nextReview: FlashcardReview { reviews.last ?? .null }
}

extension FlashcardReview {
    var card: Flashcard { repo.basis.cardMap[cardId] ?? .null }
    var deck: FlashcardDeck { card.deck }
}

extension FlashcardDeck {
    var childDecks: [FlashcardDeck] { repo.basis.basis.deckSet[id]?.values ?? [FlashcardDeck]() }
    
    var cards: [Flashcard] {
        var cards = repo.basis.basis.cardSet[id] ?? []
        return childDecks.reduce(into: cards) { cards, deck in
            cards.insert(deck.cards)
        }.values
    }
    
    var nextReviews: [FlashcardReview] { cards.compactMap(\.nextReview) }
    var openReviews: [FlashcardReview] { nextReviews.filter { $0.scheduled.start < .now } }
}
