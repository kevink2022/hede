//
//  EventManager.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import Foundation
import Models
import Database

final class EventManager {
    
    private let repository: Repository
    
    init(
        repository: Repository = Repository(inMemory: true)
    ) {
        self.repository = repository
    }
    
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
