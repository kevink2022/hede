//
//  RecurringSourcesScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI
import Models

struct RecurringSourcesScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        List {
            
            ForEach(repository.recurringSources) { source in
                NavigationLink {
                    AnySourceScreen(AnyTaskSource(source))
                } label: {
                    Text(source.label)
                }
//                    .contextMenu(ContextMenu(menuItems: {
//                        Button(role: .destructive) {
//                            Task{ await eventManager.delete([source]) }
//                        } label: {
//                            Label("Delete Source", systemImage: SI.delete)
//                        }
//                    }))
            }
        }
        .listStyle(.inset)
        .navigationTitle(T.recurringSources)
        
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
