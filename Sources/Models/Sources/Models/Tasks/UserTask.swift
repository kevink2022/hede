//
//  UserTask.swift
//
//
//  Created by Kevin Kelly on 8/30/24.
//

import Foundation
import Domain

/// A central idea to the design is the task loop:
///  1. Create the source and the inital task at the same time.
///  2. When a task is completed, the information in the completed task is used to create the next task.
///
/// Some facts about the tasks/sources:
///  1. For each 'active' source, there is always one active task.

/// A task to be displayed in the timeline or calendar.
///
/// Should be on each task, but with different signatures:
/// - `edit() -> Self`
public protocol UserTask: Codable, Identifiable, Equatable, Hashable {
    /// The unique ID of the `Task`.
    var id: Key { get }
    /// The unique ID of the `TaskSource` for this `Task`.
    var source: Key { get }
    /// The label of the `Task`.
    var label: String { get }
    /// The time the `Task` will appear on a user's timeline.
    var scheduled: TaskTime { get }
    /// The time the `Task` was completed.
    var completed: Date? { get }
    /// Facilitates coding by tying type-erased Tasks to their underlying type.
    var code: TaskCode { get }
    /// Create a copy of self with the completed date.
    func complete(date: Date?) -> Self
}

extension UserTask {
    /// Task is not completed
    public var isOpen: Bool { completed == nil }
    /// Task is completed
    public var isCompleted: Bool { completed != nil }
    /// Generic trampoline into type specific `complete()`
    public func complete(date: Date?) -> any UserTask {
        self.complete(date: date)
    }
    /// Hash the ID
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public enum TaskCode: Codable, Equatable {
    case toDo(ToDoTask)
    case recurring(RecurringTask)
//    case learning(LearningTask)
}

/// A codable, type erased `Task` container
public final class AnyTask: UserTask {
    public static func == (lhs: AnyTask, rhs: AnyTask) -> Bool {
        lhs.code == rhs.code
    }
    
    public var id: Key { data.id }
    public var source: Key { data.source }
    public var label: String { data.label }
    public var scheduled: TaskTime { data.scheduled }
    public var completed: Date? { data.completed }
    
    public func complete(date: Date?) -> AnyTask {
        return AnyTask(data.complete(date: date))
    }
    
    public var sortDate: Date { self.completed ?? self.scheduled.start }
    
    public init(_ task: any UserTask) {
        if let task = task as? AnyTask {
            self.data = task.data
        } else {
            self.data = task
        }
    }

    public let data: any UserTask
    public var code: TaskCode { data.code }
}

extension AnyTask {
    internal convenience init(code: TaskCode) {
        switch code {
        case .toDo(let task): self.init(task)
        case .recurring(let task): self.init(task)
//        case .learning(let task): self.init(task)
        }
    }
    
    internal enum CodingKeys: String, CodingKey {
        case code
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data.code, forKey: .code)
    }
    
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let code = try container.decode(TaskCode.self, forKey: .code)
        self.init(code: code)
    }
}
