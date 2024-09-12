//
//  SourceBox.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI
import Models

fileprivate typealias F = ViewConstants.Fonts

struct SourceBox: View {
    private var source: AnyTaskSource
    
    var body: some View {
        Box {
            Text(source.label)
                .font(F.boxLarge)
        } topRight: {
            Image(systemName: "")
        }
    }
    
    init(_ source: AnyTaskSource) {
        self.source = source
    }
}

#Preview {
    SourceBox(PreviewMocks.anySource)
}
