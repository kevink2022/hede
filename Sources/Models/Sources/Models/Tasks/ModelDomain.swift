import Foundation
import Domain

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
