//
//  ToDoSourcesScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/9/24.
//

import SwiftUI

fileprivate typealias C = ViewConstants.Colors
fileprivate typealias F = ViewConstants.Fonts
fileprivate typealias T = ViewConstants.Text
fileprivate typealias SI = ViewConstants.SystemImages

struct ToDoSourcesScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository

    var body: some View {
        ScrollView {
            HStack {
                Text(T.toDoSources)
                    .font(F.screenTitle)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            BoxGrid(columns: 2) {
                ForEach(repository.toDoSources) { source in
                    Box(
                        color: C.toDo
                        , bottomLeft: {
                            BoxText(source.label)
                        }
                    )
                }
                
            }
        }
        .toolbar {
            Button {
                navigator.presentSheet(Text("ToDoSourceSheet"))
            } label: {
                Image(systemName: SI.add)
            }
        }
        
        if repository.toDoSources.isEmpty {
            NoContentMessage(message: T.toDoSourcesNoContent) {
                navigator.presentSheet(Text("ToDoSourceSheet"))
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
