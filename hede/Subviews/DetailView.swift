//
//  DetailView.swift
//  hede
//
//  Created by Kevin Kelly on 1/30/25.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(value)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.trailing)
        }
    }
    
    init(
        label: String
        , value: String
    ) {
        self.label = label
        self.value = value
    }
}
