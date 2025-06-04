//
//  NavigationDestinations.swift
//  hede
//
//  Created by Kevin Kelly on 2/9/25.
//

import SwiftUI
import Models

struct NavigationDestinations: ViewModifier {
    
//    @Bindable var path: NavigationPath
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: HedeScheduler.self) { scheduler in
                SchedulerScreen(scheduler)
            }
            .navigationDestination(for: HedeTask.self) { task in
                TaskScreen(task)
            }
    }
    
//    init(for path: NavigationPath) {
//        self.path = path
//    }
}

extension View {
    func addNavigationDestinations(/*to path: NavigationPath*/) -> some View {
        self.modifier(NavigationDestinations(/*for: path*/))
    }
}
