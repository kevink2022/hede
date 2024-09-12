//
//  NoContentMessage.swift
//  hede
//
//  Created by Kevin Kelly on 9/11/24.
//

import SwiftUI

fileprivate typealias C = ViewConstants.Colors
fileprivate typealias F = ViewConstants.Fonts
fileprivate typealias T = ViewConstants.Text
fileprivate typealias V = ViewConstants


struct NoContentMessage<Content: View>: View {
    @Environment(\.navigator) private var navigator
    
    private let message: String
    private let action: () -> ()
    private let label: () -> Content

    var body: some View {
        
        Spacer()
        
        Text(message)
            .font(F.emptyScreenInformational)
            .opacity(V.noContentMessageOpacity)
        
        Button {
            action()
        } label: {
            label()
                .font(F.semiLargeSymbol)
        }
        .padding(.bottom, V.noContentBottomPadding)
    }
    
    init(
        message: String
        , action: @escaping () -> () = { }
        , @ViewBuilder label: @escaping () -> Content = { EmptyView() }
    ) {
        self.message = message
        self.action = action
        self.label = label
    }
    
}

#Preview {
    NoContentMessage(message: "No Recurring Task Sources.") {
        print("test")
        //navigator.presentSheet(RecurringSourceFormView())
    } label: {
        Label("Add Source", systemImage: "plus")
    }
    
    
}
