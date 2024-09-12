//
//  Navigator.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI

/// Centralized app navigation, facilitating links and programmatic navigation.
@Observable
final class Navigator {
    
    var tab = NavigationTab.sources {
        willSet { if tab == newValue { doubleTap(on: tab) } }
    }
   
    var home = NavigationPath()
    var settings = NavigationPath()
    var sources = NavigationPath()
    var search = NavigationPath()
    var calendar = NavigationPath()
    
    var searchIsFocused: Bool = false
    
    var showSheet: Bool = false
    var sheetContent: AnyView? = nil
    
    func presentSheet<V: View>(_ view: V) {
        self.sheetContent = AnyView(view)
        self.showSheet = true
    }
    
    func dismissSheet() {
        self.showSheet = false
    }
    
    func toTab(_ tab: NavigationTab) {
        if self.tab != tab {
            // prevent triggering double tabs on programatic navigation
            self.tab = tab
        }
    }
    
    private func doubleTap(on tab: NavigationTab) {
        switch tab {
        case .home: home.toRoot()
        case .settings: settings.toRoot()
        case .sources: sources.toRoot()
        case .search: search.toRoot()
        case .calendar: calendar.toRoot()
        }
    }
}

extension NavigationPath {
    mutating func toRoot() {
        self.removeLast(self.count)
    }
    
    mutating func navigateTo(_ value: any Hashable, clearingPath: Bool = false) {
        if clearingPath {
            self.toRoot()
        }
        self.append(value)
    }
    
    mutating func navigateBack() {
        self.removeLast()
    }
}

enum NavigationTab {
    case home, settings, sources, search, calendar
}
