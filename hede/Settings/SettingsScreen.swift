//
//  SettingsScreen.swift
//  hede
//
//  Created by Kevin Kelly on 1/20/25.
//

import SwiftUI
import Database

import Models

struct SettingsScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        @Bindable var navigator = navigator
        
        NavigationStack(path: $navigator.settings) {
            List {
                
                Section("Tasks") {
                    NavigationLink {
                        ToDoSourcesScreen()
                    } label: {
                        Label(T.toDo, systemImage: SI.toDo)
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        RecurringSourcesScreen()
                    } label: {
                        Label(T.recurring, systemImage: SI.recurring)
                    }
                    .foregroundStyle(.primary)
                }
                
                Section("Goals") {
                    NavigationLink {
                        GoalListScreen()
                    } label: {
                        Label("Goals", systemImage: "checkmark.circle.fill")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        GoalGroupListScreen()
                    } label: {
                        Label("Groups", systemImage: "checklist")
                    }
                    .foregroundStyle(.primary)
                    
                    NavigationLink {
                        AllDailyGoalListsScreen()
                    } label: {
                        Label("Daily Lists", systemImage: "sun.min")
                    }
                    .foregroundStyle(.primary)
                }
                
                
                Section("Storage") {
                    NavigationLink {
                        TransactionHistoryScreen { await repository.tasks.getTransactions() }
                            rollbackToBefore: { await repository.tasks.rollbackTo(before: $0) }
                            rollbackToAfter: { await repository.tasks.rollbackTo(after: $0) }
                    } label: {
                        Text("Task History")
                    }
                    
                    NavigationLink {
                        TransactionHistoryScreen { await repository.goals.getTransactions() }
                            rollbackToBefore: { await repository.goals.rollbackTo(before: $0) }
                            rollbackToAfter: { await repository.goals.rollbackTo(after: $0) }
                    } label: {
                        Text("Goal History")
                    }
                }
                
                Section("Debug") {
                    Button {
                        Task {
                            await repository.tasks.save(MyTasks.importAll, message: "Import Dev Defaults")
                        }
                    } label: {
                        Text("Import Dev Defaults")
                    }
                    .disabled(repository.tasks.taskSources.count > 0)
   
                }
            }
            .navigationTitle("Settings")
            .listStyle(V.listStyle)
            .addNavigationDestinations()
        }
    }
}

#Preview {
    SettingsScreen()
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}
