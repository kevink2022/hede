//
//  DeckScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/16/25.
//

import SwiftUI
import Models
import Database

extension FlashcardDeck {
    func screen() -> DeckScreen { DeckScreen(self) }
}

public struct DeckScreen: View {
    @Environment(\.repository) private var repository
    
    private var parentDeck: FlashcardDeck
    private var reviews: [FlashcardReview] { parentDeck.openReviews }
    
    @State var editing: Bool = false
    
    public var body: some View {
        List {
            if reviews.isEmpty {
                NavigationLink {
                    StudyScreen(reviews)
                } label: {
                    Label("No Cards to Review", systemImage: SI.flashcards)
                }
                .disabled(true)
            } else {
                NavigationLink {
                    StudyScreen(reviews)
                } label: {
                    Label("Study \(reviews.count) Cards", systemImage: SI.flashcards)
                }
            }
            
            Section("Sub-Decks") {
                NavigationLink {
                    
                } label: {
                    Label("Add New Sub-Deck", systemImage: SI.add)
                }
                
                
                ForEach(parentDeck.childDecks) { deck in
                    NavigationLink(value: deck) {
                        Text(deck.label)
                    }
                }
                
            }
            

            Section("Cards") {
                NavigationLink {
                    
                } label: {
                    Label("Add New Card", systemImage: SI.add)
                }
                
                Button {
                    Task {
                        parentDeck.cards.forEach {
                            print("Front: \($0.front)")
                            print("Back: \($0.back)")
                        }
                    }
                } label: {
                    Text("Print em")
                }
                 
                ForEach(parentDeck.cards) { card in
                    NavigationLink(value: card) {
                        Text(card.label)
                    }
                }
            }
             
        }
        .listStyle(.inset)
        .navigationTitle(parentDeck.label)
        .addNavigationDestinations()
    }
    
    init(_ deck: FlashcardDeck) {
        self.parentDeck = deck
    }
}
