//
//  TagField.swift
//  hede
//
//  Created by Kevin Kelly on 6/9/25.
//

import SwiftUI
import DomainUI
import Models

struct TagEntryField: View {
    @State private var text: String = ""
    @Binding private var tags: Set<HedeTag>
    @FocusState private var focused: Bool
    private let editing: Bool
    
    private var tagsByLength: [HedeTag] {
        Array(tags).sorted(by: {$0.label.count < $1.label.count} )
    }
    
    var body: some View {
        ZStack {
            Button {
                focused = true
            } label: {
                Color(UIColor.systemBackground)
            }
            .disabled(!editing)
            
            VStack(alignment: .leading) {
                WrappingHStack(horizontalSpacing: 5) {
                    ForEach(tagsByLength, id: \.self) { tag in
                        Button {
                            if editing {
                                tags.remove(tag)
                                text = tag.label
                            }
                        } label: {
                            Text(tag.label)
                                .font(F.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .fill(Color.accentColor)
                                )
                                .foregroundStyle(.white)
                        }
                    }
                }
                
                if editing {
                    Button {
                        focused = true
                    } label: {
                        VStack(alignment: .leading) {
                            TextField(text: $text, prompt: Text("Add Tag")) { EmptyView() }
                                .focused($focused)
                                .multilineTextAlignment(.leading)
                                .onSubmit {
                                    //focused = true
                                    onSubmit()
                                }
                        }
                    }
                }
            }
        }
    }
    
    private func onSubmit() {
            if let tag = HedeTag.from(text) {
                withAnimation(A.standard) {
                    tags.insert(tag)
                    text = ""
                }
            }
    }
    
    init(
        tags: Binding<Set<HedeTag>>
        , editing: Bool = false
    ) {
        self._tags = tags
        self.text = ""
        self.editing = editing
    }
}


#Preview {
    TagEntryField(tags: .constant([]))
}
