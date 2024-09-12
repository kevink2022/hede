//
//  RecurringSourcesScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI
import Models

fileprivate typealias C = ViewConstants.Colors
fileprivate typealias F = ViewConstants.Fonts
fileprivate typealias T = ViewConstants.Text
fileprivate typealias SI = ViewConstants.SystemImages

struct RecurringSourcesScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        ScrollView {
            HStack {
                Text(T.recurringSources)
                    .font(F.screenTitle)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            BoxGrid(columns: 2) {
                ForEach(repository.recurringSources) { source in
                    Box(
                        color: C.reccurring
                        , bottomLeft: {
                            BoxText(source.label)
                        }
                    )
                }
                
            }
        }
        .toolbar {
            Button {
                navigator.presentSheet(RecurringSourceFormView())
            } label: {
                Image(systemName: SI.add)
            }
        }
        
        if repository.recurringSources.isEmpty {
            NoContentMessage(message: T.recurringSourcesNoContent) {
                navigator.presentSheet(RecurringSourceFormView())
            } label: {
                Label(T.addSource, systemImage: SI.add)
            }

        }
    }
}

#Preview {
    RecurringSourcesScreen()
        .environment(PreviewMocks.repository)
//        .environment(PreviewMocks.mockRepository)
        .tint(C.reccurring)
}
