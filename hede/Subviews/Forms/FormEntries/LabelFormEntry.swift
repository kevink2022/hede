//
//  LabelFormEntry.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI

struct LabelFormEntry: View {
    
    @Binding private var label: String
    private var showHelp: Bool
    
    var body: some View {
        FormEntry(showHelp: showHelp) {
            TextField(text: $label, prompt: Text("Label")) { EmptyView() }
        } label: {
            Text("Label")
        } help: {
            Text("Label Help")
        }
    }
    
    init(
        label: Binding<String>
        , showHelp: Bool = false
    ) {
        self._label = label
        self.showHelp = showHelp
    }
}

#Preview {
    LabelFormEntry(label: .constant(""), showHelp: false)
}
