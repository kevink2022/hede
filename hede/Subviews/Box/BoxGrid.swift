//
//  BoxGrid.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI

struct BoxGrid<Content: View>: View {
    private let content: () -> Content
    private let padding: CGFloat
    private let gridItems: [GridItem]
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: padding) {
            content()
                .padding(.horizontal, padding/2)
                .padding(.vertical, padding)

        }
        .padding(.horizontal, padding)
    }
    
    init(
        columns: Int = 2
        , padding: CGFloat = V.boxExternalPadding
        , @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.padding = padding
        self.gridItems = Array(repeating: GridItem(.flexible()), count: columns)
    }
}

#Preview {
    BoxGrid {
        Box(
            topRight: { BoxImage(systemName: SI.recurring)}
            , bottomLeft: { BoxText("Hello") }
        )
        Box(
            topRight: { BoxImage(systemName: SI.recurring)}
            , bottomLeft: { BoxText("Hello") }
        )
        Box(
            topRight: { BoxImage(systemName: SI.recurring) }
            , bottomLeft: { BoxText("Hello I am the longest name, get used to it.") }
        )
        Box(
            topRight: { BoxImage(systemName: SI.recurring) }
            , bottomLeft: { BoxText("Hello I am a longer name.") }
        )
    }
}
