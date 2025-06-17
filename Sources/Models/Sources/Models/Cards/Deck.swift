//
//  Deck.swift
//  Models
//
//  Created by Kevin Kelly on 6/15/25.
//

import Foundation
import Domain


public final class FlashcardDeck: Identifiable, Codable {
    public let id: Key
    public let parentDeckId: Key?
    
    public let label: String
    public let description: String?
    
    public let tagIds: [HedeTag.ID]
    public let template: [CardElement]?
    
    internal init(
        id: Key
        , parentDeckId: Key?
        , label: String
        , description: String?
        , tagIds: [HedeTag.ID]
        , template: [CardElement]?
    ) {
        self.id = id
        self.parentDeckId = parentDeckId
        self.label = label
        self.description = description
        self.tagIds = tagIds
        self.template = template
    }
}

// MARK: - Methods

extension FlashcardDeck {
    public static func create(
        label: String
        , parent: FlashcardDeck?
        , description: String?
        , tags: [HedeTag]
        , template: [CardElement]?
    ) -> FlashcardDeck {
        .init(
            id: .new()
            , parentDeckId: parent?.id
            , label: label
            , description: description
            , tagIds: tags.map { $0.id }
            , template: template
        )
    }
    
    public func edit(
        label: String
        , parent: FlashcardDeck?
        , description: String?
        , tags: [HedeTag]
        , template: [CardElement]?
    ) -> FlashcardDeck {
        .init(
            id: self.id
            , parentDeckId: parent?.id
            , label: label
            , description: description
            , tagIds: tags.map { $0.id }
            , template: template
        )
    }
}

// MARK: - Conformance

extension FlashcardDeck: Equatable {
    public static func == (lhs: FlashcardDeck, rhs: FlashcardDeck) -> Bool {
        lhs.id == rhs.id
        && lhs.parentDeckId == rhs.parentDeckId
        && lhs.label == rhs.label
        && lhs.description == rhs.description
        && lhs.tagIds == rhs.tagIds
        && lhs.template == rhs.template
    }
}

extension FlashcardDeck: Nullable {
    public static let null = FlashcardDeck(id: .null, parentDeckId: nil, label: "NULL DECK", description: nil, tagIds: [], template: nil)
}

extension FlashcardDeck: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

