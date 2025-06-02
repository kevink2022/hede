//
//  TasksDueScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//

import SwiftUI
import Models
import Database

struct TasksDueScreen: View {
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    @Environment(\.eventManager) private var eventManager
    
    @State var showCompleted: Bool = false
    
    
    var tasksByDate: Repository.Tasks.AnyHedeTaskByDate { showCompleted ? repository.tasks.hedeTasksByDate : repository.tasks.openHedeTasksByDate }
        
    var body: some View {
        @Bindable var navigator = navigator
        
        NavigationStack(path: $navigator.home) {
            List {
                ForEach(tasksByDate, id: \.key) { group in
                    Section(header: Text(group.key)) {
                        ForEach(group.tasks, id: \.id) { task in
                            NavigationLink {
                                TaskScreen(task)
                            } label: {
                                Text(task.label)
                                    .opacity(task.isComplete ? 0.4 : 1)
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
            .addNavigationDestinations()
        }
    }
}

#Preview {
    TasksScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}

