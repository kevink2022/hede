//
//  TasksScreen.swift
//  hede
//
//  Created by Kevin Kelly on 9/11/24.
//

import SwiftUI
import Models
import Database

struct TasksScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    @Environment(\.eventManager) private var eventManager
    
    @State var showCompleted: Bool = false
    var tasksByDate: Repository.AnyTaskByDate { showCompleted ? repository.tasksByDate : repository.openTasksByDate }
        
    var body: some View {
        @Bindable var navigator = navigator
        
        NavigationStack(path: $navigator.home) {
            List {
                ForEach(tasksByDate, id: \.key) { group in
                    Section(header: Text(group.key)) {
                        ForEach(group.tasks, id: \.id) { task in
                            NavigationLink {
                                AnyTaskScreen(task)
                            } label: {
                                Text(task.label)
                                    .opacity(task.isCompleted ? 0.4 : 1)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    Task { await eventManager.complete(task) }
                                } label: {
                                    Image(systemName: SI.complete)
                                }
                                .tint(.green)
                            }
                        }
                    }
                    
                }
            }
            .listStyle(.inset)
            .navigationTitle("Tasks")
            .toolbar {
                Menu {
                    if showCompleted {
                        Button {
                            showCompleted = false
                        } label: {
                            Label("Hide Completed", systemImage: "checkmark.circle.badge.xmark")
                        }
                    } else {
                        Button {
                            showCompleted = true
                        } label: {
                            Label("Show Completed", systemImage: "checkmark.circle")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            
        }
    }
}

#Preview {
    TasksScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}

