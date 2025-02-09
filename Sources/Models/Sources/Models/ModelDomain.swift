import Foundation

/// The Identifier for any record or object in hede that needs to be identifiable. 
public struct Key: Identifiable, Codable, Equatable, Hashable, Nullable {
    public let id: UUID
    
    public static func new() -> Self { Key(id: UUID()) }
    
    /// A non-nil key that is passed to represent a nil date for setting optional parameters to nil.
    ///
    /// This should *never* be stored, any optional keys should be stored as nil. This is only for setting keys to nil when they are opitionally passed.
    /// Storing this key to represent a nil key will break, as a new one is generated on each launch of the app.
    public static let null = Key(id: UUID())
}

/// Passable as explicitly null when optional means 'ignore.'
public protocol Nullable: Equatable {
    /// The representation of a 'null' object. 
    ///
    /// This object should never be stored permanently, as it may change between sessions.
    static var null: Self { get }
}

extension Nullable {
    /// Turn a null into a nil.
    public func nulled() -> Self? {
        return self == .null ? nil : self
    }
}

extension Optional where Wrapped: Nullable {
    /// Compare a newer nullable to an original value.
    ///
    /// If the nullable is null, returns nil. If the nullable is nil, returns the original. Otherwise, returns itself.
    public func null(or original: Wrapped?) -> Wrapped? {
        switch self {
        case .some(let value) where value == Wrapped.null:
            return nil
        case .none:
            return original
        case .some(let value):
            return value
        }
    }
}

extension Date: Nullable {
    public static let null = Date(timeIntervalSince1970: 0)
}

extension String: Nullable {
    public static let null = ""
}

extension Array: Nullable where Element: Equatable {
    public static var null: Array<Element> {
        return []
    }
}

extension AnyTaskSource: Nullable {
    public static let null = AnyTaskSource(ToDoSource.null)
}

extension AnyTask: Nullable {
    public static let null = AnyTask(ToDoTask.null)
}

extension ToDoSource: Nullable {
    public static let null = ToDoSource.create(
        label: "NULL TODO SOURCE"
        , description: "NULL TODO SOURCE"
        , time: .reminder(.null)
        , category: nil
        , pauses: nil
    ).source
}

extension ToDoTask: Nullable {
    public static let null = ToDoSource.create(
        label: "NULL TODO TASK"
        , description: "NULL TODO TASK"
        , time: .reminder(.null)
        , category: nil
        , pauses: nil
    ).initialTask
}

extension RecurringSource: Nullable {
    public static let null = RecurringSource.create(
        label: "NULL RECURRING SOURCE"
        , description: "NULL RECURRING SOURCE"
        , taskType: .reminder
        , recurranceType: .fromScheduled
        , spacing: .weeks(1)
        , lastCompleted: nil
        , category: nil
        , pauses: nil
    ).source
}

extension RecurringTask: Nullable {
    public static let null = RecurringSource.create(
        label: "NULL RECURRING TASK"
        , description: "NULL RECURRING TASK"
        , taskType: .reminder
        , recurranceType: .fromScheduled
        , spacing: .weeks(1)
        , lastCompleted: nil
        , category: nil
        , pauses: nil
    ).initialTask
}
