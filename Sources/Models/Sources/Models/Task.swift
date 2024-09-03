//
//  Task.swift
//
//
//  Created by Kevin Kelly on 8/30/24.
//

import Foundation

/// A central idea to the design is the task loop:
///  1. Create the source and the inital task at the same time.
///  2. When a task is completed, the information in the completed task is used to create the next task.

/// A task to be displayed in the timeline or calendar.
///
/// Should be on each task, but with different signatures:
/// - `edit() -> Self`
public protocol Task: Codable, Identifiable, Equatable {
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
    /// Create a copy of self with the completed date.
    func complete(date: Date?) -> Self
}

extension Task {
    /// Task is not completed
    public var isOpen: Bool { completed == nil }
    /// Task is completed
    public var isCompleted: Bool { completed != nil }
    /// Generic trampoline into type specific `complete()`
    public func complete(date: Date?) -> any Task {
        self.complete(date: date)
    }
}

/// A codable, type erased `Task` container
public final class AnyTask: Task {
    public static func == (lhs: AnyTask, rhs: AnyTask) -> Bool {
        lhs.code == rhs.code
    }
    
    public var id: Key { data.id }
    public var source: Key { data.source }
    public var label: String { data.label }
    public var scheduled: TaskTime { data.scheduled }
    public var completed: Date? { data.completed }
    
    public func complete(date: Date?) -> AnyTask {
        return AnyTask(task.complete(date: date))
    }
    
    public var task: any Task { data as (any Task) }
    
    public init(_ task: any Task) {
        self.data = task as! any TaskCodable
    }
    
    internal let data: any TaskCodable
    internal var code: TaskCode { data.code }
}

/// This allows `any Task` to be coded as an `AnyTask`
internal protocol TaskCodable: Task {
    var code: TaskCode { get }
}

internal enum TaskCode: Codable, Equatable {
    case toDo(ToDoTask)
    case recurring(ReccuringTask)
}

extension AnyTask {
    internal convenience init(code: TaskCode) {
        switch code {
        case .toDo(let toDoTask): self.init(toDoTask)
        case .recurring(let reccuringTask): self.init(reccuringTask)
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
