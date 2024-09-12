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
        
        await repository.save([AnyTaskSource(source), AnyTask(initialTask)])
    }
    
    func createToDo(from form: ToDoSourceForm) async {
        guard form.canSave else { return }
        
        let (source, task) = ToDoSource.create(
            label: form.label
            , description: form.description.nulled()
            , time: <#T##TaskTime#>
            , category: form.category?.id
            , pauses: form.pauses?.map({ $0.id }).nulled()
        )
        
        await repository.save([AnyTaskSource(source), AnyTask(task)])
    }
}
