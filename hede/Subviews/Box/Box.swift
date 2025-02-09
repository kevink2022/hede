//
//  Box.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI

struct Box<
    TopLeft: View
    , TopRight: View
    , BottomLeft: View
    , BottomRight: View
>: View {
    private let topLeft: () -> TopLeft
    private let topRight: () -> TopRight
    private let bottomLeft: () -> BottomLeft
    private let bottomRight: () -> BottomRight
    
    private let color: Color
    private let cornerRadius: CGFloat
    private let opacity: Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: V.boxCorner)
                .foregroundStyle(color)
                .opacity(opacity)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        topLeft()
                            .opacity(V.boxTextOpacity)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        topRight()
                            .opacity(V.boxTextOpacity)
                    }
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        bottomLeft()
                            .opacity(V.boxTextOpacity)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        bottomRight()
                            .opacity(V.boxTextOpacity)
                    }
                }
            }
            .padding(V.boxInternalPadding)
            .frame(minHeight: 96)
        }
    }
    
    init(
        color: Color? = nil
        , cornerRadius: CGFloat? = nil
        , opacity: Double? = nil
        , @ViewBuilder topLeft: @escaping () -> TopLeft = { EmptyView() }
        , @ViewBuilder topRight: @escaping () -> TopRight = { EmptyView() }
        , @ViewBuilder bottomLeft: @escaping () -> BottomLeft = { EmptyView() }
        , @ViewBuilder bottomRight: @escaping () -> BottomRight = { EmptyView() }
    ) {
        self.color = color ?? .blue
        self.cornerRadius = cornerRadius ?? V.boxCorner
        self.opacity = opacity ?? V.boxOpacity
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
}

#Preview {
    Box {
        Text("Top Left")
            .font(F.boxLarge)
    } /*topRight: {
        Text("Top Right")
    } */bottomLeft: {
        Text("Bottom Left")
            .font(F.boxSmall)
    } bottomRight: {
        Text("Bottom Right")
            .font(F.boxSmall)
    }
}




