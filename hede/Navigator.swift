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
            case .home: print("Get home"); return home
            case .settings: print("Get settings"); return settings
            case .sources: print("Get sources"); return sources
            case .search: print("Get search"); return search
            case .calendar: print("Get calendar"); return calendar
            }
        }
        set {
            switch tab {
            case .home: print("Get home"); home = newValue
            case .settings: print("Get settings"); settings = newValue
            case .sources: print("Get sources"); sources = newValue
            case .search: print("Get search"); search = newValue
            case .calendar: print("Get calendar"); calendar = newValue
            }
        }
    }
    
    func toRoot() { here.toRoot() }
    func navigateTo(_ value: any Hashable, clearingPath: Bool = false) { here.navigateTo(value, clearingPath: clearingPath) }
    func navigateBack() { here.navigateBack() }
    
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
    mutating func toRoot() { self.removeLast(self.count) }
    
    mutating func navigateTo(_ value: any Hashable, clearingPath: Bool = false) {
        if clearingPath { self.toRoot() }
        self.append(value)
    }
    
    mutating func navigateBack() {
        print(self.count)
        guard self.count > 0 else { return }
        self.removeLast()
    }
}

enum NavigationTab {
    case home, settings, sources, search, calendar
}
