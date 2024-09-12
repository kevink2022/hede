//
//  Environment.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import SwiftUI
import Database

struct RepositoryEnvironmentKey: EnvironmentKey {
    static let defaultValue: Repository = Repository(inMemory: true)
}

struct NavigatorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Navigator = Navigator()
}

struct EventManagerEnvironmentKey: EnvironmentKey {
    static let defaultValue: EventManager = EventManager()
}

extension EnvironmentValues {
    var repository: Repository {
        get { self[RepositoryEnvironmentKey.self] }
        set { self[RepositoryEnvironmentKey.self] = newValue }
    }
    
    var navigator: Navigator {
        get { self[NavigatorEnvironmentKey.self] }
        set { self[NavigatorEnvironmentKey.self] = newValue }
    }
    
    var eventManager: EventManager {
        get { self[EventManagerEnvironmentKey.self] }
        set { self[EventManagerEnvironmentKey.self] = newValue }
    }
}
