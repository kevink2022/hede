//
//  TaskQueries.swift
//  Database
//
//  Created by Kevin Kelly on 5/31/25.
//

import Foundation
import Models
import Domain

extension TaskRepository {
    public var hedeTasks: [HedeTask] { basis.hedeTasks }
    public var openHedeTasks: [HedeTask] { basis.hedeTasks.filter { !$0.isComplete } }
    public var hedeSchedulers: [HedeScheduler] { basis.hedeSchedulers }
    public var hedeTags: [HedeTag] { basis.hedeTags }
    
    public func hedeTasks(_ ids: [Key]) -> [HedeTask] { ids.compactMap { basis.hedeTaskMap[$0] } }
    public func hedeSchedulers(_ ids: [Key]) -> [HedeScheduler] { ids.compactMap { basis.hedeSchedulerMap[$0] } }
    public func hedeTags(_ ids: [Key]) -> [HedeTag] { ids.compactMap { basis.hedeTagsMap[$0] } }
}

/// Tasks grouped by date
extension Array where Element == HedeTask {
    internal func groupByDate() -> [(key: String, tasks: [HedeTask])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return self.reduce(into: [(key: String, tasks: [HedeTask])]()) { result, task in
            let dateKey = formatter.string(from: task.sortDate)
            if let lastGroup = result.last, lastGroup.key == dateKey {
                result[result.count - 1].tasks.append(task)
            } else {
                result.append((key: dateKey, tasks: [task]))
            }
        }
    }
}

extension TaskRepository {
    public typealias AnyHedeTaskByDate = [(key: String, tasks: [HedeTask])]
    public var hedeTasksByDate: AnyHedeTaskByDate { hedeTasks.groupByDate() }
    public var openHedeTasksByDate: AnyHedeTaskByDate { openHedeTasks.groupByDate() }
}

extension HedeScheduler {
    public var tasks: [HedeTask] { Repository.system.tasks.hedeTasks.filter { $0.schedulerId == self.id } }
}

extension HedeTask {
    public var scheduler: HedeScheduler { Repository.system.tasks.hedeSchedulers([self.schedulerId]).first ?? .null }
}

// MARK: - DEPR
extension TaskRepository {
    public var tasks: [AnyTask] { basis.tasks }
    public var openTasks: [AnyTask] { basis.tasks.filter { $0.isOpen } }
    public var taskSources: [AnyTaskSource] { basis.taskSources }
    public var categories: [TaskCategory] { basis.categories }
    public var pauses: [TaskPause] { basis.pauses }
    
    public func tasks(_ ids: [Key]) -> [AnyTask] { ids.compactMap { basis.taskMap[$0] } }
    public func taskSources(_ ids: [Key]) -> [AnyTaskSource] { ids.compactMap { basis.taskSourceMap[$0] } }
    public func categories(_ ids: [Key]) -> [TaskCategory] { ids.compactMap { basis.categoryMap[$0] } }
    public func pauses(_ ids: [Key]) -> [TaskPause] { ids.compactMap { basis.pauseMap[$0] } }
    
    public var toDoTasks: [ToDoSource] { basis.taskSources.compactMap { $0.data as? ToDoSource } }
    public var recurringTasks: [RecurringSource] { basis.taskSources.compactMap { $0.data as? RecurringSource } }
    
    public var toDoSources: [ToDoSource] { basis.taskSources.compactMap { $0.data as? ToDoSource } }
    public var recurringSources: [RecurringSource] { basis.taskSources.compactMap { $0.data as? RecurringSource } }
}

/// Tasks grouped by date
extension Array where Element == AnyTask {
    internal func groupByDate() -> [(key: String, tasks: [AnyTask])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return self.reduce(into: [(key: String, tasks: [AnyTask])]()) { result, task in
            let dateKey = formatter.string(from: task.sortDate)
            if let lastGroup = result.last, lastGroup.key == dateKey {
                result[result.count - 1].tasks.append(task)
            } else {
                result.append((key: dateKey, tasks: [task]))
            }
        }
    }
}

extension TaskRepository {
    public typealias AnyTaskByDate = [(key: String, tasks: [AnyTask])]
    public var tasksByDate: AnyTaskByDate { tasks.groupByDate() }
    public var openTasksByDate: AnyTaskByDate { openTasks.groupByDate() }
}

extension AnyTaskSource {
    public var tasksLink: [AnyTask] { Repository.system.tasks.tasks.filter { $0.source == self.id } }
}

extension AnyTask {
    public var sourceLink: AnyTaskSource { Repository.system.tasks.taskSources([self.source]).first ?? .null }
}

extension ToDoSource {
    public var tasksLink: [ToDoTask] {
        Repository.system.tasks.tasks
            .filter { $0.source == self.id }
            .compactMap{ $0.data as? ToDoTask }
    }
}

extension ToDoTask {
    public var sourceLink: ToDoSource {
        Repository.system.tasks.taskSources([self.source]).first?.data as? ToDoSource ?? .null
    }
}

extension RecurringSource {
    public var tasksLink: [RecurringTask] {
        Repository.system.tasks.tasks
            .filter { $0.source == self.id }
            .compactMap{ $0.data as? RecurringTask }
    }
}

extension RecurringTask {
    public var sourceLink: RecurringSource {
        Repository.system.tasks.taskSources([self.source]).first?.data as? RecurringSource ?? .null
    }
}

