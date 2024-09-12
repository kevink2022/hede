//
//  PreviewMocks.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import Foundation
import Models
import Database

extension Repository {
    fileprivate func syncSave(_ models: [any Savable], message: String? = nil) {
        Task {
            await save(models)
        }
    }
}

struct PreviewMocks {
    static let repository = Repository(inMemory: true)
    static let eventManager = EventManager(repository: repository)
    
    static let mockRepository: Repository = {
        let repository = Repository(inMemory: true)
        repository.syncSave(sources + tasks)
        return repository
    }()
    
    static let mockEventManager = EventManager(repository: mockRepository)
    
    static let mar_1_2001 = Date(timeIntervalSince1970: 983404800)
    static let feb_1_2001 = Date(timeIntervalSince1970: 980985600)
    static let apr_1_2001 = Date(timeIntervalSince1970: 986083200)
    
    static let one_week_behind = base.subtracting(.weeks(1))!
    static let base = Date.now
    static let five_hours_ahead = base.adding(.hours(5))!
    static let one_week_ahead = base.adding(.weeks(1))!
    static let one_month_ahead = base.adding(.months(1))!
    
    static let task = ToDoSource.create(
        label: "Test Task"
        , description: nil
        , time: .task(mar_1_2001)
        , category: nil
        , pauses: nil
    ).initialTask
    
    static let taskSource = ToDoSource.create(
        label: "Test Task"
        , description: nil
        , time: .task(mar_1_2001)
        , category: nil
        , pauses: nil
    ).source
    
    static let category = TaskCategory(
        id: Key.new()
        , label: "Test Category"
        , description: nil
        , pauses: nil
    )
    
    static let pause = TaskPause(
        id: Key.new()
        , label: "Test Pause"
        , description: nil
    )
    
    static let anyTask = AnyTask(task)
    static let anySource = AnyTaskSource(taskSource)
    
    static let toDo_1 = ToDoSource.create(
        label: "Buy Beer for Game"
        , description: "Pat likes coors."
        , time: .deadline(one_week_ahead)
        , category: nil
        , pauses: nil
    )
    
    static let toDo_2 = ToDoSource.create(
        label: "Text Michael about new creami flavor."
        , description: "He would be too smart to say yes."
        , time: .deadline(one_week_behind)
        , category: nil
        , pauses: nil
    )
    
    static let toDo_3 = ToDoSource.create(
        label: "Return Jeans"
        , description: "Made my ass look fat"
        , time: .deadline(one_week_behind)
        , category: nil
        , pauses: nil
    )
    
    static let toDos = [toDo_1, toDo_2, toDo_3]
    static let toDoSources = toDos.map { $0.source }
    static let toDoTasks = toDos.map { $0.initialTask }
    
    static let recurring_1 = RecurringSource.create(
        label: "Do Leetcode problem"
        , description: "Practice Patterns"
        , taskType: .reminder
        , recurranceType: .fromComplete
        , spacing: .weeks(1)
        , lastCompleted: one_week_behind
        , category: nil
        , pauses: nil
    )
    
    static let recurring_2 = RecurringSource.create(
        label: "Wash Sheets"
        , description: nil
        , taskType: .reminder
        , recurranceType: .fromComplete
        , spacing: .weeks(2)
        , lastCompleted: one_week_behind
        , category: nil
        , pauses: nil
    )
    
    static let recurring_3 = RecurringSource.create(
        label: "Pay Rent"
        , description: nil
        , taskType: .deadline
        , recurranceType: .fromScheduled
        , spacing: .months(1)
        , lastCompleted: one_week_behind
        , category: nil
        , pauses: nil
    )
    
    static let recurring = [recurring_1, recurring_2, recurring_3]
    static let recurringSources = recurring.map { $0.source }
    static let recurringTasks = recurring.map { $0.initialTask }
    
    static let sources = toDoSources.map { AnyTaskSource($0) } + recurringSources.map { AnyTaskSource($0) }
    static let tasks = toDoTasks.map { AnyTask($0) } + recurringTasks.map { AnyTask($0) }
}


