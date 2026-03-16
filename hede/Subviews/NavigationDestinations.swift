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
            .navigationDestination(for: HedeScheduler.self) { SchedulerScreen($0) }
            .navigationDestination(for: HedeTask.self) { TaskScreen($0) }
            .navigationDestination(for: FlashcardDeck.self) { $0.screen() }
            .navigationDestination(for: Flashcard.self) { $0.screen() }
            .navigationDestination(for: [CardElement].self) { CardElementGroupView($0) }
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
