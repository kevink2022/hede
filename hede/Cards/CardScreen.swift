//
//  CardContentScreen.swift
//  hede
//
//  Created by Kevin Kelly on 7/3/25.
//

import SwiftUI
import Models
import DomainUI

extension Flashcard {
    func screen() -> CardScreen { .init(self) }
}

struct CardScreen: View {
    let card: Flashcard
    
    var reviewHistory: [FlashcardReview] { card.reviews }
    
    var body: some View {
        List {
            NavigationLink {
                CardContentScreen(card)
            } label: {
                Label("Card Content", systemImage: SI.flashcards)
            }
             
            Section("Next Review") {
                DetailRow(label: card.label, value: card.nextReview.sortDate.shortFormat)
            }
            
            Section("Review History") {
                ForEach(card.reviews.dropFirst()) { review in
                    DetailRow(label: card.label, value: review.sortDate.shortFormat)
                }
            }
             
        }
        .listStyle(.inset)
        .navigationTitle(card.label)
        .addNavigationDestinations()
    }
    
    init(_ card: Flashcard) { self.card = card }
}

struct CardReviewHistoryList: View {
    
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
