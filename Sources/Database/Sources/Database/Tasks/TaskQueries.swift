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
    public var tags: [HedeTag] { Repository.system.tasks.hedeTags(tagIds) }
}

extension HedeTask {
    public var scheduler: HedeScheduler { Repository.system.tasks.hedeSchedulers([self.schedulerId]).first ?? .null }
}
