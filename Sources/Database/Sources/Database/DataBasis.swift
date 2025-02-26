//
//  File.swift
//  
//
//  Created by Kevin Kelly on 9/3/24.
//

import Foundation
import Models
import Assemblages
import Domain

internal protocol Basis {
    var basis: DataBasis { get }
    static var empty: Self { get }
    init(_ basis: MutableBasis)
}

internal final class DataBasis: Basis {
    internal var basis: DataBasis { self }
    
    internal let taskSet: ExternallySortedKeySet<AnyTask>
    public var tasks: [AnyTask] { taskSet.values }
    public var taskMap: [Key: AnyTask] { taskSet.dictionary }
    
    internal let taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
    public var taskSources: [AnyTaskSource] { taskSourceSet.values }
    public var taskSourceMap: [Key: AnyTaskSource]  { taskSourceSet.dictionary }
    
    internal let categorySet: ExternallySortedKeySet<TaskCategory>
    public var categories: [TaskCategory] { categorySet.values }
    public var categoryMap: [Key: TaskCategory] { categorySet.dictionary }
    
    internal let pauseSet: ExternallySortedKeySet<TaskPause>
    public var pauses: [TaskPause] { pauseSet.values }
    public var pauseMap: [Key: TaskPause] { pauseSet.dictionary }
    
    internal init(
        taskSet: ExternallySortedKeySet<AnyTask>
        , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
        , categorySet: ExternallySortedKeySet<TaskCategory>
        , pauseSet: ExternallySortedKeySet<TaskPause>
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
    }
    
    public convenience init(
        tasks: [AnyTask]? = nil
        , taskSources: [AnyTaskSource]? = nil
        , categories: [TaskCategory]? = nil
        , pauses: [TaskPause]? = nil
    ) {
        self.init(
            taskSet: ExternallySortedKeySet<AnyTask>(
                set: KeySet<AnyTask>().inserting(contentsOf: tasks ?? [])
            )
            , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>(
                set: KeySet<AnyTaskSource>().inserting(contentsOf: taskSources ?? [])
            )
            , categorySet: ExternallySortedKeySet<TaskCategory>(
                set: KeySet<TaskCategory>().inserting(contentsOf: categories ?? [])
            )
            , pauseSet: ExternallySortedKeySet<TaskPause>(
                set: KeySet<TaskPause>().inserting(contentsOf: pauses ?? [])
            )
        )
    }
    

    public convenience init() {
        self.init(
            taskSet: ExternallySortedKeySet<AnyTask>()
            , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>()
            , categorySet: ExternallySortedKeySet<TaskCategory>()
            , pauseSet: ExternallySortedKeySet<TaskPause>()
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
        )
    }
    
    public static let empty = DataBasis()
}

internal final class MutableBasis {
    var taskSet: ExternallySortedKeySet<AnyTask>
    var taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
    var categorySet: ExternallySortedKeySet<TaskCategory>
    var pauseSet: ExternallySortedKeySet<TaskPause>

    init(
        taskSet: ExternallySortedKeySet<AnyTask>
        , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
        , categorySet: ExternallySortedKeySet<TaskCategory>
        , pauseSet: ExternallySortedKeySet<TaskPause>
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
    }
    
    convenience init(
        _ basis: DataBasis
    ) {
        self.init(
            taskSet: basis.taskSet
            , taskSourceSet: basis.taskSourceSet
            , categorySet: basis.categorySet
            , pauseSet: basis.pauseSet
        )
    }
}
