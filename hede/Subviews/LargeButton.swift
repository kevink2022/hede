//
//  LargeButton.swift
//  Boomic
//
//  Created by Kevin Kelly on 3/17/24.
//

import SwiftUI

struct LargeButton<Label>: View where Label: View {
    let role: ButtonRole?
    let action: () -> Void
    let label: () -> Label
    
    init(
        role: ButtonRole? = nil
        , action: @escaping () -> Void
        , @ViewBuilder label: @escaping () -> Label
    ) {
        self.role = role
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(role: role, action: action) {
            ZStack {
                RoundedRectangle(cornerSize: CGSize(
                        width: V.buttonCornerRadius,
                        height: V.buttonCornerRadius)
                    )
                    .fill(.secondary)
                    .opacity(0.4)
                
                label()
                    .font(F.largeButtonText)
            }
        }
    }
}

#Preview {
    LargeButton {
        
    } label: {
        HStack {
            Image(systemName: "play.fill")
            Text("Play")
        }
    }
}
