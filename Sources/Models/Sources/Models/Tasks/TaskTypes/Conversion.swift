//
//  Conversion.swift
//  Models
//
//  Created by Kevin Kelly on 5/31/25.
//

import Foundation
import Domain

extension HedeTask {
    public convenience init(convert task: AnyTask) {
        self.init(
            id: task.id
            , schedulerId: task.source
            , label: task.label
            , scheduled: task.scheduled
            , completed: task.completed
            , state: nil
            , review: nil
        )
    }
}

extension HedeScheduler {
    public convenience init(convert source: AnyTaskSource) {
        let algo: AnySpacedRepetition? = {
            switch source.code {
            case .recurring(let source): AnySpacedRepetition(LinearSpacedRepetition(spacing: source.spacing))
            case .toDo(_): nil
            }
        }()
        
        let pattern: RecurrencePattern? = {
            switch source.code {
            case .recurring(let source): {
                switch source.type {
                case .fromComplete: .fromComplete
                case .fromScheduled: .fromScheduled
                }
            }()
            case .toDo(_): nil
            }
        }()
        
        self.init(
            id: source.id
            , label: source.label
            , description: source.description
            // never used these so nil is fine
            , tagIds: []
            , active: true
            , algorithm: algo
            , recurrencePattern: pattern ?? .fromComplete
        )
    }
}

