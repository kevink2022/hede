//
//  ContentView.swift
//  hede
//
//  Created by Kevin Kelly on 8/30/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.navigator) var navigator
    
    var body: some View {
        @Bindable var navigator = navigator
        
        TabView(selection: $navigator.tab) {
            SettingsScreen()
                .tabItem { Label(T.settings, systemImage: SI.settings) }
                .tag(NavigationTab.settings)
            
            Text("Calendar")
                .tabItem { Label(T.calendar, systemImage: SI.calendar) }
                .tag(NavigationTab.calendar)
            
            TasksDueScreen() //TasksScreen() //HomeScreen()
                .tabItem { Label(T.home, systemImage: SI.home) }
                .tag(NavigationTab.home)
            
            NavigationStack(path: $navigator.search) { ParentDecksScreen() }
                .tabItem { Label("Cards", systemImage: SI.flashcards) }
                .tag(NavigationTab.search)
            
            DailyGoalFormScreen()
                .tabItem { Label(T.sources, systemImage: SI.sources) }
                .tag(NavigationTab.sources)
        }
        
        .sheet(isPresented: $navigator.showSheet) {
            if let content = navigator.sheetContent {
                content
            }
        }
    }
}

#Preview {
    ContentView()
//        .environment(\.repository, PreviewMocks.repository)
//        .environment(\.eventManager, PreviewMocks.eventManager)
        .environment(\.repository, PreviewMocks.mockRepository)
        .environment(\.eventManager, PreviewMocks.mockEventManager)
}
