//
//  ToDoSourcesScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI
import Models

struct ToDoSourcesScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository

    var body: some View {
        List {
            
            ForEach(repository.toDoSources) { source in
                NavigationLink {
                    AnySourceScreen(AnyTaskSource(source))
                } label: {
                    Text(source.label)
                }
                
                .contextMenu(ContextMenu(menuItems: {
                    Button(role: .destructive) {
                        Task { await eventManager.delete([source]) }
                    } label: {
                        Label("Delete Source", systemImage: SI.delete)
                    }
                }))
            }
                
        }
        .listStyle(.inset)
        .navigationTitle(T.toDoSources)

        .toolbar {
            Button {
                navigator.presentSheet(ToDoSourceFormView())
            } label: {
                Image(systemName: SI.add)
            }
        }
        
        if repository.toDoSources.isEmpty {
            NoContentMessage(message: T.toDoSourcesNoContent) {
                navigator.presentSheet(ToDoSourceFormView())
            } label: {
                Label(T.addSource, systemImage: SI.add)
            }
        }
    }
}

#Preview {
    ToDoSourcesScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}
