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
        let date = Date.now
        guard let scheduler = repository.tasks.hedeSchedulers([task.schedulerId]).first else { return }
        
        // temp -- will need to pass review from UIs once they're created.
        let tempReview: AnySpacedRepetitionContext? = {
            switch scheduler.algorithm?.code {
            case .linear(_): AnySpacedRepetitionContext(LinearSpacedRepetition.Review(date: date))
            case nil: nil
            default: nil
            }
        }()
        
        let completedTask = task.complete(at: date, review: tempReview)
       
        if let newTask = scheduler.nextTask(from: completedTask) {
            print("NEW TASK - SCHEDULED: \(newTask.scheduled.dateLabel)")
            await repository.tasks.save([completedTask, newTask], message: "Completed \(completedTask.label)")
        } else {
            print("NO NEW TASK")
            await repository.tasks.save([completedTask], message: "Completed \(completedTask.label)")
        }
    }
}

// Create/delete
extension EventManager {
    /*
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
        
        await repository.tasks.save([AnyTaskSource(source), AnyTask(initialTask)], message: "Created Recurring Source: \(source.label)")
    }
    
    func editRecurring(from form: RecurringSourceForm) async {
        guard form.canSave else { return }
        
        guard
            let currentSource = form.source
            , let lastTask = form.lastTask
        else { return }
        
        let (newSource, newTask) = currentSource.edit(
            label: form.label
            , description: form.description.nulled()
            , category: form.category?.id
            , pauses: form.pauses?.map({ $0.id }).nulled()
            , taskType: form.taskType
            , type: form.recurrenceType
            , spacing: form.spacing
            , lastTask: lastTask
        )
        
        await repository.tasks.save([AnyTaskSource(newSource), AnyTask(newTask)], message: "Edited ToDo Source: \(newSource.label)")
    }
     */
    
}

/// Goals
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
