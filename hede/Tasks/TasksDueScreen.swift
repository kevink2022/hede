//
//  TasksDueScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//

import SwiftUI
import Models
import Database
import Domain

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
                            NavigationLink(value: task) {
                                Text(task.label)
                                    .opacity(task.isComplete ? 0.4 : 1)
                            }
                            .swipeActions(edge: .leading) {
                                if !task.isComplete {
                                    Button {
                                        completeTask(task)
                                    } label: {
                                        Image(systemName: SI.complete)
                                    }
                                    .tint(.green)
                                }
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
    
    private func completeTask(_ task: HedeTask) {
        switch task.scheduler.algorithm?.code {
        case .linear: Task { await eventManager.complete(task, with: AnySpacedRepetitionContext(LinearSpacedRepetition.Review(date: .now))) }
        case .ankiFSRS_5: navigator.here.navigateTo(task)
        case nil: Task { await eventManager.complete(task) }
        default: Task { await eventManager.complete(task) }
        }
    }
}

#Preview {
    TasksDueScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
}

