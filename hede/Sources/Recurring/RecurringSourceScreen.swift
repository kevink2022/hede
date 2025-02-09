//
//  RecurringSourceScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/17/24.
//

import SwiftUI
import Models

struct RecurringSourceScreen: View {
    let source: RecurringSource
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(source.label)
                    .font(F.screenTitle)
                
                if let description = source.description {
                    Text(description)
                }
            }
            
            Spacer()
        }
        .padding(V.standardPadding)
        
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ source: RecurringSource) {
        self.source = source
    }
}

#Preview {
    RecurringSourceScreen(PreviewMocks.recurring_1.source)
}
