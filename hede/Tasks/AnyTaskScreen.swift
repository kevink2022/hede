//
//  AnyTaskScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/18/24.
//

import SwiftUI
import Models

struct AnyTaskScreen: View {
    
    private let task: AnyTask
    
    @Environment(\.navigator) private var navigator
    @Environment(\.eventManager) private var eventManager
    @Environment(\.repository) private var repository
    
    private var source: AnyTaskSource {
        AnyTaskSource(repository.taskSources([task.source]).first?.data ?? ToDoSource.null)
    }
    
    var body: some View {
        List {
                if let description = source.description {
                    VStack(alignment: .leading) {
                        Text(description)
                            .padding(.top, 24)
                    }
                }
                                
                DetailRow(label: "Scheduled:", value: task.scheduled.start.formatted())
                                
                DetailRow(label: "Completed:", value: task.completed?.formatted() ?? "Not Completed")
                                
                switch task.code {
                case .toDo(_): EmptyView()
                case .recurring(let recurringTask): RecurringTaskFields(recurringTask)
                }
                
        }
        .navigationTitle(task.label)
        .listStyle(.inset)
                    
        .toolbar {
            Button {
                navigator.here.navigateTo(source)
            } label: {
                Image(systemName: SI.edit)
            }
            
            Button {
                
            } label: {
                Image(systemName: SI.delete)
            }
        }
    }
    
    init(_ task: AnyTask) {
        self.task = task
    }
}

#Preview {
    AnyTaskScreen(AnyTask(PreviewMocks.toDo_1.initialTask))
        .environment(\.repository, PreviewMocks.mockRepository)
}
