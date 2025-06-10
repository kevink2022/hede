//
//  AllSchedulersScreen.swift
//  hede
//
//  Created by Kevin Kelly on 6/1/25.
//
import SwiftUI
import DomainUI

import Models

struct AllSchedulersScreen: View {
    @Environment(\.eventManager) private var eventManager
    @Environment(\.navigator) private var navigator
    @Environment(\.repository) private var repository
    
    private var activeSchedulers: [HedeScheduler] { repository.tasks.hedeSchedulers.filter { $0.active } }
    private var inactiveSchedulers: [HedeScheduler] { repository.tasks.hedeSchedulers.filter { !$0.active } }
    
    var body: some View {
        List {
            
            NavigationLink {
                SchedulerFormView()
            } label: {
                Label("Add New Task", systemImage: SI.add)
            }
            
            if !activeSchedulers.isEmpty {
                Section("Active Tasks") {
                    ForEach(activeSchedulers) { scheduler in
                        NavigationLink {
                            scheduler.screen()
                        } label: {
                            Text(scheduler.label)
                        }
                    }
                }
            }
            
            if !inactiveSchedulers.isEmpty {
                Section("Archived Tasks") {
                    ForEach(inactiveSchedulers) { scheduler in
                        NavigationLink {
                            scheduler.screen()
                        } label: {
                            Text(scheduler.label)
                        }
                    }
                }
            }
            
            
        }
        .listStyle(.inset)
        .navigationTitle("Task Schedulers")
    }
}

#Preview {
    AllSchedulersScreen()
        .environment(PreviewMocks.repository)
//        .environment(PreviewMocks.mockRepository)
        .tint(C.reccurring)
}
