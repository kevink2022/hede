//
//  TaskMocks.swift
//  hede
//
//  Created by Kevin Kelly on 3/3/25.
//

import Foundation
import Models
import Domain
import Database

extension PreviewMocks {
    static let mar_1_2001 = Date(timeIntervalSince1970: 983404800)
    static let feb_1_2001 = Date(timeIntervalSince1970: 980985600)
    static let apr_1_2001 = Date(timeIntervalSince1970: 986083200)
    
    static let one_week_behind = base.subtracting(.weeks(1))!
    static let base = Date.now
    static let five_hours_ahead = base.adding(.hours(5))!
    static let one_week_ahead = base.adding(.weeks(1))!
    static let one_month_ahead = base.adding(.months(1))!
    
    static let mocks = [
            
        HedeScheduler.create(
            label: "Buy Beer for Game"
            , description: "Pat likes coors."
            , tags: []
            , algorithm: nil
            , recurrencePattern: .fromComplete
            , startOn: .task(five_hours_ahead)
        )
        
        , HedeScheduler.create(
            label: "Text Michael about new creami flavor."
            , description: "He would be too smart to say yes."
            , tags: []
            , algorithm: nil
            , recurrencePattern: .fromComplete
            , startOn: .task(one_week_behind)
        )
        
        , HedeScheduler.create(
            label: "Call with Aaron"
            , description: "Stonls"
            , tags: []
            , algorithm: nil
            , recurrencePattern: .fromComplete
            , startOn: .appointment(start: one_week_ahead, end: one_week_ahead.adding(.hours(2))!)
        )
        
        , HedeScheduler.create(
            label: "Do Leetcode problem"
            , description: "Practice Patterns"
            , tags: []
            , algorithm: AnySpacedRepetition(LinearSpacedRepetition(spacing: .weeks(1)))
            , recurrencePattern: .fromComplete
            , startOn: .task(one_week_ahead)
        )
        
        , HedeScheduler.create(
            label: "Wash Sheets"
            , description: nil
            , tags: []
            , algorithm: AnySpacedRepetition(LinearSpacedRepetition(spacing: .weeks(2)))
            , recurrencePattern: .fromComplete
            , startOn: .reminder(one_week_behind)
        )
        
        , HedeScheduler.create(
            label: "Pay Rent"
            , description: nil
            , tags: []
            , algorithm: AnySpacedRepetition(LinearSpacedRepetition(spacing: .months(1)))
            , recurrencePattern: .fromScheduled
            , startOn: .deadline(one_week_behind)
        )
    ]
    
    static let schedulers = mocks.map { $0.scheduler }
    static let tasks = mocks.map { $0.task }
}
