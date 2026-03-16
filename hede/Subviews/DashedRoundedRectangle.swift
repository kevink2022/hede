//
//  DashedRoundedRectangle.swift
//  hede
//
//  Created by Kevin Kelly on 6/18/25.
//

import SwiftUI

struct CardElementConfig: View {
    
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(style: StrokeStyle(
                lineWidth: 2,
                dash: [10, 10]
            ))
            .foregroundColor(.blue)
            .frame(width: 200, height: 100)
    }
}

#Preview {
    CardElementConfig()
}
