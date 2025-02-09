//
//  DescriptionFormEntry.swift
//  hede
//
//  Created by Kevin Kelly on 9/12/24.
//

import SwiftUI

struct DescriptionFormEntry: View {
    
    @Binding private var description: String
    private var showHelp: Bool
    
    var body: some View {
        FormEntry(showHelp: showHelp) {
            TextField(text: $description, prompt: Text("Description")) { EmptyView() }
        } label: {
            Text("Description")
        } help: {
            Text("Label Help")
        }
    }
    
    init(
        description: Binding<String>
        , showHelp: Bool = false
    ) {
        self._description = description
        self.showHelp = showHelp
    }
}
#Preview {
    DescriptionFormEntry(description: .constant(""), showHelp: false)
}
