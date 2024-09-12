//
//  ContentView.swift
//  hede
//
//  Created by Kevin Kelly on 8/30/24.
//

import SwiftUI

fileprivate typealias T = ViewConstants.Text
fileprivate typealias SI = ViewConstants.SystemImages

struct ContentView: View {
    @Environment(\.navigator) var navigator
    
    var body: some View {
        @Bindable var navigator = navigator
        
        TabView(selection: $navigator.tab) {
            Text("Settings")
                .tabItem { Label(T.settings, systemImage: SI.settings) }
                .tag(NavigationTab.settings)
            
            Text("Calendar")
                .tabItem { Label(T.calendar, systemImage: SI.calendar) }
                .tag(NavigationTab.calendar)
            
            TasksScreen() //HomeScreen()
                .tabItem { Label(T.home, systemImage: SI.home) }
                .tag(NavigationTab.home)
            
            SourcesScreen()
                .tabItem { Label(T.sources, systemImage: SI.sources) }
                .tag(NavigationTab.sources)
            
            Text("Search")
                .tabItem { Label(T.search, systemImage: SI.search) }
                .tag(NavigationTab.search)
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
