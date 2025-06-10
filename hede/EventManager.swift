//
//  EventManager.swift
//  hede
//
//  Created by Kevin Kelly on 9/8/24.
//

import Foundation
import Models
import Database
import Domain

/// Class for triggering events that will write to the repository
final class EventManager {
    
    private let repository: Repository
    
    init(
        repository: Repository = Repository(inMemory: true)
    ) {
        self.repository = repository
    }
    
    func delete(_ models: [any Savable]) async {
        await repository.tasks.delete(models)
    }
    
    func complete(_ task: HedeTask, with review: AnySpacedRepetitionContext? = nil) async {
        guard let scheduler = repository.tasks.hedeSchedulers([task.schedulerId]).first else { return }
        
        let completedTask = task.complete(at: .now, review: review)
       
        if let newTask = scheduler.nextTask(from: completedTask) {
            await repository.tasks.save([completedTask, newTask], message: "Completed \(completedTask.label)")
        } else {
            await repository.tasks.save([completedTask], message: "Completed \(completedTask.label)")
        }
    }
}

// MARK: - Tasks
extension EventManager {
    func save(from form: SchedulerForm) async {
        guard form.valid else { return }
        
        return await form.editing ? edit(from: form) : create(from: form)
    }
    
    private func create(from form: SchedulerForm) async {
        guard form.valid else { return }
        
        let result = HedeScheduler.create(
            label: form.label
            , description: form.description
            , tags: Array(form.tags)
            , algorithm: form.algorithm
            , recurrencePattern: form.recurrencePattern
            , startOn: form.startOn
        )
        
        return await repository.tasks.save([result.scheduler, result.task], message: "Create Task: \(form.label)")
    }
    
    private func edit(from form: SchedulerForm) async {
        guard form.valid else { return }
        
        guard
            let currentScheduler = form.scheduler
            , let lastTask = form.lastTask
        else { return }
        
        
        let result = currentScheduler.edit(
            label: form.label
            , description: form.description
            , tags: Array(form.tags)
            , algorithm: form.algorithm
            , recurrencePattern: form.recurrencePattern
            , startOn: form.startOn
            , lastCompletedTask: lastTask
        )
        
        return await repository.tasks.save([result], message: "Edit Task: \(form.label)")
    }
}

// MARK: - Goals
extension EventManager {
    func saveGoal(from form: GoalForm) async {
        guard form.canSave else { return }
        guard let newGoal = form.create() else { return }
        let message = form.isNew ? "Create Goal: \(newGoal.label)" : "Edit Goal: \(newGoal.label)"
        await repository.goals.save([newGoal], message: message)
    }
    
    func saveGoalGroup(from form: GoalGroupForm) async {
        guard form.canSave else { return }
        guard let newGoalGroup = form.create() else { return }
        let message = form.isNew ? "Create Goal Group: \(newGoalGroup.label)" : "Edit Goal Group: \(newGoalGroup.label)"
        await repository.goals.save([newGoalGroup], message: message)
    }
    
    func saveGoalList(from form: DailyListForm) async {
        guard form.canSave else { return }
        guard let newList = form.create() else { return }
        let message = form.isNew ? "Create Daily List: \(newList.label)" : "Edit Daily List: \(newList.label)"
        await repository.goals.save([newList], message: message)
    }
}
