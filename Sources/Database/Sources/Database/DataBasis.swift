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
    
    // Tasks
    internal let taskSet: ExternallySortedKeySet<AnyTask>
    internal let taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
    internal let categorySet: ExternallySortedKeySet<TaskCategory>
    internal let pauseSet: ExternallySortedKeySet<TaskPause>
    
    // Goals
    internal let dailyGoalSet: ExternallySortedKeySet<DailyGoal>
    internal let dailyGoalResultSet: ExternallySortedKeySet<DailyGoalResult>
    internal let dailyGoalListSet: ExternallySortedKeySet<DailyGoalList>
    internal let dailyGoalListSectionSet: ExternallySortedKeySet<DailyGoalListSection>
    internal let routineSet: ExternallySortedKeySet<Routine>
    internal let routineStepSet: ExternallySortedKeySet<RoutineStep>
    internal let routineResultSet: ExternallySortedKeySet<RoutineResult>
    internal let routineStepResultSet: ExternallySortedKeySet<RoutineStepResult>
    
    internal init(
        taskSet: ExternallySortedKeySet<AnyTask>
        , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
        , categorySet: ExternallySortedKeySet<TaskCategory>
        , pauseSet: ExternallySortedKeySet<TaskPause>
        , dailyGoalSet: ExternallySortedKeySet<DailyGoal>
        , dailyGoalResultSet: ExternallySortedKeySet<DailyGoalResult>
        , dailyGoalListSet: ExternallySortedKeySet<DailyGoalList>
        , dailyGoalListSectionSet: ExternallySortedKeySet<DailyGoalListSection>
        , routineSet: ExternallySortedKeySet<Routine>
        , routineStepSet: ExternallySortedKeySet<RoutineStep>
        , routineResultSet: ExternallySortedKeySet<RoutineResult>
        , routineStepResultSet: ExternallySortedKeySet<RoutineStepResult>
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
        self.dailyGoalSet = dailyGoalSet
        self.dailyGoalResultSet = dailyGoalResultSet
        self.dailyGoalListSet = dailyGoalListSet
        self.dailyGoalListSectionSet = dailyGoalListSectionSet
        self.routineSet = routineSet
        self.routineStepSet = routineStepSet
        self.routineResultSet = routineResultSet
        self.routineStepResultSet = routineStepResultSet
    }

    public convenience init() {
        self.init(
            taskSet: ExternallySortedKeySet<AnyTask>()
            , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>()
            , categorySet: ExternallySortedKeySet<TaskCategory>()
            , pauseSet: ExternallySortedKeySet<TaskPause>()
            , dailyGoalSet: ExternallySortedKeySet<DailyGoal>()
            , dailyGoalResultSet: ExternallySortedKeySet<DailyGoalResult>()
            , dailyGoalListSet: ExternallySortedKeySet<DailyGoalList>()
            , dailyGoalListSectionSet: ExternallySortedKeySet<DailyGoalListSection>()
            , routineSet: ExternallySortedKeySet<Routine>()
            , routineStepSet: ExternallySortedKeySet<RoutineStep>()
            , routineResultSet: ExternallySortedKeySet<RoutineResult>()
            , routineStepResultSet: ExternallySortedKeySet<RoutineStepResult>()
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
            , dailyGoalSet: basis.dailyGoalSet
            , dailyGoalResultSet: basis.dailyGoalResultSet
            , dailyGoalListSet: basis.dailyGoalListSet
            , dailyGoalListSectionSet: basis.dailyGoalListSectionSet
            , routineSet: basis.routineSet
            , routineStepSet: basis.routineStepSet
            , routineResultSet: basis.routineResultSet
            , routineStepResultSet: basis.routineStepResultSet
        )
    }
    
    public static let empty = DataBasis()
}

internal final class MutableBasis {
    
    // Tasks
    var taskSet: ExternallySortedKeySet<AnyTask>
    var taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
    var categorySet: ExternallySortedKeySet<TaskCategory>
    var pauseSet: ExternallySortedKeySet<TaskPause>
    
    // Goals
    var dailyGoalSet: ExternallySortedKeySet<DailyGoal>
    var dailyGoalResultSet: ExternallySortedKeySet<DailyGoalResult>
    var dailyGoalListSet: ExternallySortedKeySet<DailyGoalList>
    var dailyGoalListSectionSet: ExternallySortedKeySet<DailyGoalListSection>
    var routineSet: ExternallySortedKeySet<Routine>
    var routineStepSet: ExternallySortedKeySet<RoutineStep>
    var routineResultSet: ExternallySortedKeySet<RoutineResult>
    var routineStepResultSet: ExternallySortedKeySet<RoutineStepResult>
    

    init(
        taskSet: ExternallySortedKeySet<AnyTask>
        , taskSourceSet: ExternallySortedKeySet<AnyTaskSource>
        , categorySet: ExternallySortedKeySet<TaskCategory>
        , pauseSet: ExternallySortedKeySet<TaskPause>
        , dailyGoalSet: ExternallySortedKeySet<DailyGoal>
        , dailyGoalResultSet: ExternallySortedKeySet<DailyGoalResult>
        , dailyGoalListSet: ExternallySortedKeySet<DailyGoalList>
        , dailyGoalListSectionSet: ExternallySortedKeySet<DailyGoalListSection>
        , routineSet: ExternallySortedKeySet<Routine>
        , routineStepSet: ExternallySortedKeySet<RoutineStep>
        , routineResultSet: ExternallySortedKeySet<RoutineResult>
        , routineStepResultSet: ExternallySortedKeySet<RoutineStepResult>
    ) {
        self.taskSet = taskSet
        self.taskSourceSet = taskSourceSet
        self.categorySet = categorySet
        self.pauseSet = pauseSet
        self.dailyGoalSet = dailyGoalSet
        self.dailyGoalResultSet = dailyGoalResultSet
        self.dailyGoalListSet = dailyGoalListSet
        self.dailyGoalListSectionSet = dailyGoalListSectionSet
        self.routineSet = routineSet
        self.routineStepSet = routineStepSet
        self.routineResultSet = routineResultSet
        self.routineStepResultSet = routineStepResultSet
    }
    
    convenience init(
        _ basis: DataBasis
    ) {
        self.init(
            taskSet: basis.taskSet
            , taskSourceSet: basis.taskSourceSet
            , categorySet: basis.categorySet
            , pauseSet: basis.pauseSet
            , dailyGoalSet: basis.dailyGoalSet
            , dailyGoalResultSet: basis.dailyGoalResultSet
            , dailyGoalListSet: basis.dailyGoalListSet
            , dailyGoalListSectionSet: basis.dailyGoalListSectionSet
            , routineSet: basis.routineSet
            , routineStepSet: basis.routineStepSet
            , routineResultSet: basis.routineResultSet
            , routineStepResultSet: basis.routineStepResultSet
        )
    }
}
