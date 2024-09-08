//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/3/24.
//

import Foundation
import Models
import Domain

public final class DataBasis {
    internal let taskSet: SortedSet<AnyTask>
    public var tasks: [AnyTask] { taskSet.values }
    public let taskMap: [Key: AnyTask]
    
    internal let taskSourceSet: SortedSet<AnyTaskSource>
    public var taskSources: [AnyTaskSource] { taskSourceSet.values }
    public let taskSourceMap: [Key: AnyTaskSource]
    
    internal let categorySet: SortedSet<TaskCategory>
    public var categories: [TaskCategory] { categorySet.values }
    public let categoryMap: [Key: TaskCategory]
    
    internal let pauseSet: SortedSet<TaskPause>
    public var pauses: [TaskPause] { pauseSet.values }
    public let pauseMap: [Key: TaskPause]
    
    internal init(
        taskSet: SortedSet<AnyTask>
        , taskSourceSet: SortedSet<AnyTaskSource>
        , categorySet: SortedSet<TaskCategory>
        , pauseSet: SortedSet<TaskPause>
        , taskMap: [Key: AnyTask]
        , taskSourceMap: [Key: AnyTaskSource]
        , categoryMap: [Key: TaskCategory]
        , pauseMap: [Key: TaskPause]
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
        self.taskMap = taskMap
        self.taskSourceMap = taskSourceMap
        self.categoryMap = categoryMap
        self.pauseMap = pauseMap
    }
    /*
    public convenience init(
        tasks: [AnyTask]? = nil
        , taskSources: [AnyTaskSource]? = nil
        , categories: [TaskCategory]? = nil
        , pauses: [TaskPause]? = nil
    ) {
        self.init(
            taskSet: SortedSet<AnyTask>().inserting(contentsOf: tasks ?? [])
            , taskSourceSet: SortedSet<AnyTaskSource>().inserting(contentsOf: taskSources ?? [])
            , categorySet: SortedSet<TaskCategory>().inserting(contentsOf: categories ?? [])
            , pauseSet: SortedSet<TaskPause>().inserting(contentsOf: pauses ?? [])
            , taskMap:
            , taskSourceMap:
            , categoryMap:
            , pauseMap:
        )

    }
    */
    
    public convenience init() {
        self.init(
            taskSet: SortedSet<AnyTask>()
            , taskSourceSet: SortedSet<AnyTaskSource>()
            , categorySet: SortedSet<TaskCategory>()
            , pauseSet: SortedSet<TaskPause>()
            , taskMap: [Key: AnyTask]()
            , taskSourceMap: [Key: AnyTaskSource]()
            , categoryMap: [Key: TaskCategory]()
            , pauseMap: [Key: TaskPause]()
        )
    }
    
    internal convenience init(
        _ basis: MutableBasis
    ) {
        self.init(
            taskSet: basis.taskSet
            , taskSourceSet: basis.taskSourceSet
            , categorySet: basis.categorySet
            , pauseSet: basis.pauseSet
            , taskMap: basis.taskMap
            , taskSourceMap: basis.taskSourceMap
            , categoryMap: basis.categoryMap
            , pauseMap: basis.pauseMap
        )
    }
    
    public static let empty = DataBasis()
}

internal final class MutableBasis {
    var taskSet: SortedSet<AnyTask>
    var taskSourceSet: SortedSet<AnyTaskSource>
    var categorySet: SortedSet<TaskCategory>
    var pauseSet: SortedSet<TaskPause>

    var taskMap: [Key: AnyTask]
    var taskSourceMap: [Key: AnyTaskSource]
    var categoryMap: [Key: TaskCategory]
    var pauseMap: [Key: TaskPause]
    
    init(
        taskSet: SortedSet<AnyTask>
        , taskSourceSet: SortedSet<AnyTaskSource>
        , categorySet: SortedSet<TaskCategory>
        , pauseSet: SortedSet<TaskPause>
        , taskMap: [Key: AnyTask]
        , taskSourceMap: [Key: AnyTaskSource]
        , categoryMap: [Key: TaskCategory]
        , pauseMap: [Key: TaskPause]
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
        self.taskMap = taskMap
        self.taskSourceMap = taskSourceMap
        self.categoryMap = categoryMap
        self.pauseMap = pauseMap
    }
    
    convenience init(
        _ basis: DataBasis
    ) {
        self.init(
            taskSet: basis.taskSet
            , taskSourceSet: basis.taskSourceSet
            , categorySet: basis.categorySet
            , pauseSet: basis.pauseSet
            , taskMap: basis.taskMap
            , taskSourceMap: basis.taskSourceMap
            , categoryMap: basis.categoryMap
            , pauseMap: basis.pauseMap
        )
    }
}

extension AnyTask: SetSortable {
    public static func compare(_ a: AnyTask, _ b: AnyTask) -> Bool {
        a.completed ?? a.scheduled.start > b.completed ?? b.scheduled.start
    }
    public static func isEqual(_ a: AnyTask, _ b: AnyTask) -> Bool {
        a.id == b.id
    }
}

extension AnyTaskSource: SetSortable {
    public static func compare(_ a: AnyTaskSource, _ b: AnyTaskSource) -> Bool {
        a.label.compare(b.label, options: .caseInsensitive) == .orderedAscending
    }
    public static func isEqual(_ a: AnyTaskSource, _ b: AnyTaskSource) -> Bool {
        a.id == b.id
    }
}

extension TaskCategory: SetSortable {
    public static func compare(_ a: TaskCategory, _ b: TaskCategory) -> Bool {
        a.label.compare(b.label, options: .caseInsensitive) == .orderedAscending
    }
    public static func isEqual(_ a: TaskCategory, _ b: TaskCategory) -> Bool {
        a.id == b.id
    }
}

extension TaskPause: SetSortable {
    public static func compare(_ a: TaskPause, _ b: TaskPause) -> Bool {
        a.label.compare(b.label, options: .caseInsensitive) == .orderedAscending
    }
    public static func isEqual(_ a: TaskPause, _ b: TaskPause) -> Bool {
        a.id == b.id
    }
}
