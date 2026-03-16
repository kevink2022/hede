//
//  CardContentScreen.swift
//  hede
//
//  Created by Kevin Kelly on 7/3/25.
//

import SwiftUI
import Models
import DomainUI

struct CardContentScreen: View {
    @State private var card: CardForm
    @State private var editing: Bool = false
    
    var body: some View {
        VStack(spacing: V.standardPadding) {
            if editing {
                TextField("Label", text: $card.label)
                    .textFieldStyle(.plain)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.top, V.standardPadding)
                
                Divider()
            }
            
            ScrollView {
                
                Divider()
                
                Text("FRONT")
                
                Divider()
                
                CardElementGroupView($card.front, editing: $editing)
                    .padding(.horizontal, V.standardPadding)
                
                if editing {
                    NewCardView($card.front)
                        .padding(.horizontal, V.standardPadding)
                }
                
                Divider()
                
                Text("BACK")
                
                Divider()
            
                CardElementGroupView($card.back, editing: $editing)
                    .padding(.horizontal, V.standardPadding)

                
                if editing {
                    NewCardView($card.back)
                        .padding(.horizontal, V.standardPadding)
                }
            }
            .padding(.vertical, editing ? -V.standardPadding : 0)
        }
        
        .toolbar {
            if editing {
                Button {
                    editing.toggle()
                    
                } label: {
                    Text("Save")
                }
            } else {
                Button {
                    editing.toggle()
                } label: {
                    Image(systemName: SI.edit)
                }
            }
        }
        
        .navigationTitle(editing ? "" : card.label)
    }
    
    init(_ card: Flashcard) { self.card = CardForm(card: card) }
}

@Observable
class CardForm {
    let card: Flashcard?
    
    var deck: FlashcardDeck
    var label: String
    var front: [CardElement]
    var back: [CardElement]
    
    init() {
        self.card = nil
        self.deck = .null
        self.label = "New Card"
        self.front = []
        self.back = []
    }
    
    init(front: [CardElement], back: [CardElement]) {
        self.card = nil
        self.deck = .null
        self.label = .null
        self.front = front
        self.back = back
    }
    
    init(card: Flashcard) {
        self.card = card
        self.deck = card.deck
        self.label = card.label
        self.front = card.front
        self.back = card.back
    }
    
    /*
    func save() -> (Flashcard, FlashcardReview) {
        if let card = card {
            
        } else {
            Flashcard.create(
                label: <#T##String#>
                , deck: <#T##FlashcardDeck#>
                , front: <#T##[CardElement]#>
                , back: <#T##[CardElement]#>
            )
        }
    }
     */
}

struct NewCardView: View {
    @Binding private var elements: [CardElement]
    
    var body: some View {
        VStack {
            Menu {
                Button {
                    elements.append(.init(label: "Label", media: .text("Text")))
                } label: {
                    Label("Text", systemImage: "textformat.characters")
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: StrokeStyle(
                            lineWidth: 2,
                            dash: [10, 10]
                        ))
                        .foregroundColor(.blue)
                
                    Image(systemName: SI.add)
                }
            }
        }
        .frame(height: 50)
    }
    
    init(_ elements: Binding<[CardElement]>) {
        self._elements = elements
    }
}

struct CardElementEditView: View {
    @Binding private var element: CardElement
    
    @State private var label: String
    @State private var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: StrokeStyle(
                    lineWidth: 2,
                    dash: [10, 10]
                ))
                .foregroundColor(.blue)
            
            VStack {
                TextField("", text: $label)
                    .font(.title3).opacity(0.5)
                    .multilineTextAlignment(.center)
                
                switch element.media {
                case .text:
                    TextEditor(text: $text)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                    
                case .audio/*(let cardMediaSource)*/: Text("AudioElement")
                case .image/*(let cardMediaSource)*/: Text("ImageElement")
                case .video/*(let cardMediaSource)*/: Text("VideoElement")
                case .page(let elements): NavigationLink(value: elements) { Text(element.label) }
                        .padding()
                }
                
            }
            .padding()
        }
        .fixedSize(horizontal: false, vertical: true)
        
        .onChange(of: label) { oldValue, newValue in
            element.label = newValue
        }
        
        .onChange(of: text) { oldValue, newValue in
            element.media = .text(newValue)
        }
        
        .task { initMedia(with: element.media) }
    }
    
    init(_ element: Binding<CardElement>) {
        self._element = element
        
        self.label = element.wrappedValue.label
        self.text = ""
    }
    
    private func initMedia(with media: CardMedia) {
        if case .text(let string) = media {
            self.text = string
        }
    }
}

struct CardElementTextEditor: View {
    private let element: CardElement
    
    var body: some View {
        EmptyView()
    }
}

#Preview {
    NavigationStack {
        CardContentScreen(PreviewMocks.cards[15])
    }
}
