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
    
    var tab = NavigationTab.home {
        willSet { if tab == newValue { doubleTap(on: tab) } }
    }
   
    var home: NavigationPath
    var settings: NavigationPath
    var sources: NavigationPath
    var search: NavigationPath
    var calendar: NavigationPath
    
    init() {
        self.home = NavigationPath()
        self.settings = NavigationPath()
        self.sources = NavigationPath()
        self.search = NavigationPath()
        self.calendar = NavigationPath()
    }
    
    var here: NavigationPath {
        get {
            switch tab {
            case .home: return home
            case .settings: return settings
            case .sources: return sources
            case .search: return search
            case .calendar: return calendar
            }
        }
        set {
            switch tab {
            case .home: home = newValue
            case .settings: settings = newValue
            case .sources: sources = newValue
            case .search: search = newValue
            case .calendar: calendar = newValue
            }
        }
    }
    
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
        if clearingPath { self.toRoot() }
        self.append(value)
    }
    
    mutating func navigateBack() {
        guard self.count > 0 else { return }
        self.removeLast()
    }
}

enum NavigationTab {
    case home, settings, sources, search, calendar
}
