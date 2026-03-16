//
//  ParentDecksScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/16/25.
//

import SwiftUI
import Models
import Database
import DomainUI

public struct ParentDecksScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    @State private var edit: Bool = false
    
    private var decks: [FlashcardDeck] { repository.tasks.parentDecks }
    private var reviews: [FlashcardReview] { decks.openReviews }
    
    public var body: some View {
        List {
            NavigationLink {
                StudyScreen(reviews)
            } label: {
                edit ?
                    Label("Add New Deck", systemImage: SI.add)
                    : Label(reviews.isEmpty ? "No Cards to Review" : "Study \(reviews.count) Cards", systemImage: SI.flashcards)
            }
            .disabled(reviews.isEmpty)
            
            Section("Decks") {
                ForEach(decks) { deck in
                    NavigationLink(value: deck) {
                        HStack {
                            Text(deck.label)
                            Spacer()
                            Text("(\(deck.allOpenReviews.count))")
                                .font(.subheadline)
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            Button {
                withAnimation { edit.toggle() }
            } label: {
                Image(systemName: edit ? SI.flashcards : SI.edit)
            }
        })
        
        .listStyle(.inset)
        .navigationTitle("Decks")
        .addNavigationDestinations()
    }
}

#Preview {
    ParentDecksScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}
