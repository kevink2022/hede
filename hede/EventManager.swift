//
//  EventManager.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import Foundation
import Models
import Database

/// Class for triggering events that will write to the repository
final class EventManager {
    
    private let repository: Repository
    
    init(
        repository: Repository = Repository(inMemory: true)
    ) {
        self.repository = repository
    }
    
    func delete(_ models: [any Savable]) async {
        await repository.delete(models)
    }
    
    func delete(_ toDoSources: [ToDoSource]) async {
        let models = toDoSources.compactMap { AnyTaskSource($0) as (any Savable) }
        await repository.delete(models)
    }
    
    func complete(_ anyTask: AnyTask) async {
        guard let source = repository.taskSources([anyTask.source]).first else { return }
        let completedTask = anyTask.complete(date: .now)
        
        if let newTask = source.generateNewTask(from: completedTask) {
            await repository.save([completedTask, newTask], message: "Completed \(completedTask.label)")
        } else {
            await repository.save([completedTask], message: "Completed \(completedTask.label)")
        }
    }
}

/// ToDo
extension EventManager {
    func createToDo(from form: ToDoSourceForm) async {
        guard form.canSave else { return }
        
        let (source, task) = ToDoSource.create(
            label: form.label
            , description: form.description.nulled()
            , time: form.taskTime
            , category: form.category?.id
            , pauses: form.pauses?.map({ $0.id }).nulled()
        )
        
        await repository.save([AnyTaskSource(source), AnyTask(task)], message: "Created To Do Source: \(source.label)")
    }
    
    func editToDo(from form: ToDoSourceForm) async {
        guard form.canSave else { return }
        
        guard let currentSource = form.source else { return }
        guard let lastTask = form.lastTask else { return }
        
        let (newSource, newTask) = currentSource.edit(
            label: form.label
            , description: form.description.nulled()
            , category: form.category?.id
            , pauses: form.pauses?.map({ $0.id }).nulled()
            , currentTask: lastTask
            , scheduled: form.taskTime
            , completed: form.completed
        )
        
        await repository.save([AnyTaskSource(newSource), AnyTask(newTask)], message: "Edited ToDo Source: \(newSource.label)")
    }
}

/// Recurring
extension EventManager {
    func createRecurring(from form: RecurringSourceForm) async {
        guard form.canSave else { return }
        
        let (source, initialTask) = RecurringSource.create(
            label: form.label
            , description: form.description.nulled()
            , taskType: form.taskType
            , recurranceType: form.recurrenceType
            , spacing: form.spacing
            , lastCompleted: form.lastCompleted
            , category: form.category?.id
            , pauses: form.pauses?.map({ $0.id }).nulled()
        )
        
        await repository.save([AnyTaskSource(source), AnyTask(initialTask)], message: "Created Recurring Source: \(source.label)")
    }
    
}

/// Learning
extension EventManager { }
