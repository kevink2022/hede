//
//  ToDoTaskScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/23/24.
//

import SwiftUI
import Models

struct ToDoTaskScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
    private let task: ToDoTask
    private var source: ToDoSource {
        repository.taskSources([task.source]).first?.source as? ToDoSource ?? .null
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.label)
                    .font(F.screenTitle)
                
                if let description = source.description {
                    Text(description)
                }
                
                Text(task.scheduled.dateTimeLabel)
                
                Spacer()
                
                LargeButton {
                    Task { await eventManager.complete(AnyTask(task)) }
                    navigator.home.toRoot()
                } label: {
                    HStack {
                        Spacer()
                        
                        Label("Complete", systemImage: SI.complete)
                            .font(F.screenTitle)
                            .padding(V.boxInternalPadding)
                    }
                }
                .foregroundStyle(.green)
                .frame(maxHeight: 70)
            }
            
            Spacer()
        }
        .padding(V.standardPadding)
        
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ task: ToDoTask) {
        self.task = task
    }
}

#Preview {
    ToDoTaskScreen(PreviewMocks.toDo_1.initialTask)
        .environment(\.repository, PreviewMocks.mockRepository)
}
