//
//  CardIndices.swift
//  Database
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Models
import Assemblages

extension FlashcardDeck: StringSortedIndex { }

extension Flashcard: BasisGroupIndex {
    typealias IndexType = FlashcardDeck.ID
    static func index(_ element: Flashcard) -> FlashcardDeck.ID { element.deckId }
}

/*
extension FlashcardReview: BasisGroupIndex {
    typealias IndexType = Flashcard.ID
    static func index(_ element: FlashcardReview) -> Flashcard.ID { element.cardId }
}
*/

extension FlashcardDeck: BasisGroupIndex {
    typealias IndexType = FlashcardDeck.ID?
    static func index(_ element: FlashcardDeck) -> FlashcardDeck.ID? { element.parentDeckId }
}

extension FlashcardReview: BasisSortedGroupIndex {
    typealias IndexType = Flashcard.ID
    static func index(_ element: FlashcardReview) -> Flashcard.ID { element.cardId }
    static func lessThan(lhs: FlashcardReview, rhs: FlashcardReview) -> Bool {
        lhs.sortDate < rhs.sortDate
    }
}
