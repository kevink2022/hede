//
//  hedeApp.swift
//  hede
//
//  Created by Kevin Kelly on 8/30/24.
//

import SwiftUI
import Database

@main
struct hedeApp: App {
    let repository: Repository
    let eventManager: EventManager
    
    init() {
        let repository = Repository.system
        let eventManager = EventManager(repository: repository)
        
        self.repository = repository
        self.eventManager = eventManager
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.repository, repository)
                .environment(\.eventManager, eventManager)
        }
    }
}
