//
//  PreviewMocks.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import Foundation
import Models
import Database
import Domain

extension Repository {
    fileprivate func syncSave(_ models: [any Savable], message: String? = nil) {
        Task {
            await tasks.save(models)
        }
    }
}

struct PreviewMocks {
    static let repository: Repository = .inMemory
    static let eventManager = EventManager(repository: repository)
    
    static let mockRepository: Repository = {
        let repository = Repository.system
        
        Task {
            let transactions = await repository.tasks.getTransactions()
            if let last = transactions.last {
                await repository.tasks.rollbackTo(before: last)
            }
            
            await repository.tasks.save(sources + tasks)
        }
        
        Task {
            let transactions = await repository.goals.getTransactions()
            if let last = transactions.last {
                await repository.goals.rollbackTo(before: last)
            }
            
            await repository.goals.save(goals + sections + lists)
        }
        
        return repository
    }()
    
    static let mockEventManager = EventManager(repository: mockRepository)
}

extension Date {
    static func from(day: Int, month: Int, year: Int) -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)
    }
}
