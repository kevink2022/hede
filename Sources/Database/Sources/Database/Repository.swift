//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/5/24.
//

import Foundation
import Observation
import Assemblages
import Storage
import Models
import Combine
import Domain


@Observable
public final class Repository {
    public let tasks: TaskRepository
    
    public typealias Tasks = TaskRepository
    
    public init(
        inMemory: Bool = false
    ) {
        self.tasks = TaskRepository(inMemory: inMemory)
    }
    
}

public final class UserEventLog: Codable {
    public let label: String
    internal let assertions: KeySet<Assertion>

    public var changes: [any Savable] { assertions.values.compactMap { $0 as any Savable } }
    
    internal init(
        label: String
        , assertions: KeySet<Assertion>
    ) {
        self.label = label
        self.assertions = assertions
    }
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


