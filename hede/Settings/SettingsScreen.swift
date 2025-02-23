//
//  SettingsScreen.swift
//  hede
//
//  Created by Kevin Kelly on 1/20/25.
//

import SwiftUI
import Database

struct SettingsScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    var body: some View {
        @Bindable var navigator = navigator
        
        NavigationStack(path: $navigator.settings) {
            List {
                
                Section("Sources") {
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
                
                
                Section("Storage") {
                    NavigationLink {
                        TransactionHistoryScreen()
                    } label: {
                        Text("Transaction History")
                    }
                
                    Button {
                        Task {
                            await repository.save(MyTasks.importAll, message: "Import Dev Defaults")
                        }
                    } label: {
                        Text("Import Dev Defaults")
                    }
                    .disabled(repository.taskSources.count > 0)
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
}

