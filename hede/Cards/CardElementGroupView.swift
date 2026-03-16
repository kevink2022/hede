//
//  CardElementGroupView.swift
//  hede
//
//  Created by Kevin Kelly on 6/28/25.
//

import SwiftUI
import Models

struct CardElementGroupView: View {
    @Binding private var elements: [CardElement]
    @Binding private var editing: Bool
    
    var body: some View {
        VStack {
            ForEach(elements.indices, id: \.self) { index in
                if editing {
                    CardElementEditView($elements[index])
                        .id("\(index)-\(editing)")
                } else {
                    CardElementStudyView(elements[index])
                }
            }
            
        }
    }
    
    init(
        _ elements: Binding<[CardElement]>
        , editing: Binding<Bool> = .constant(false)
    ) {
        self._elements = elements
        self._editing = editing
    }
    
    init(
        _ elements: [CardElement]
    ) {
        self._elements = .constant(elements)
        self._editing = .constant(false)
    }
}


struct CardElementStudyView: View {
    private let element: CardElement
    
    var body: some View {
        VStack {
            Text(element.label)
                .font(.footnote).opacity(0.5)
                .multilineTextAlignment(.center)
            
            switch element.media {
            case .text(let string):
                Text(string)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
            case .audio/*(let cardMediaSource)*/: Text("AudioElement")
            case .image/*(let cardMediaSource)*/: Text("ImageElement")
            case .video/*(let cardMediaSource)*/: Text("VideoElement")
            case .page(let elements): NavigationStack { NavigationLink(value: elements) { Text(element.label) } }
            }
        }
    }
    
    init(_ element: CardElement) {
        self.element = element
    }
}

#Preview {
    CardElementGroupView(
        .constant([
            .init(label: "Label 1", media: .text("Media 1"))
            , .init(label: "Label 2", media: .text("Media 2"))
        ])
        , editing: .constant(true)
    )
}
