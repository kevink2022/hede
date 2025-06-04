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
    internal let hedeSchedulerSet: IndexSortedKeySet<HedeScheduler>
    internal let hedeTaskSet: IndexSortedKeySet<HedeTask>
    internal let hedeTagSet: IndexSortedKeySet<HedeTag>
    
    // Goals
    internal let dailyGoalSet: IndexSortedKeySet<DailyGoal>
    internal let dailyGoalResultSet: IndexGroupedKeySet<DailyGoalResult, Date>
    internal let dailyGoalListSet: IndexSortedKeySet<DailyGoalList>
    internal let dailyGoalListSectionSet: IndexSortedKeySet<DailyGoalListSection>
    internal let routineSet: IndexSortedKeySet<Routine>
    internal let routineStepSet: IndexSortedKeySet<RoutineStep>
    internal let routineResultSet: IndexSortedKeySet<RoutineResult>
    internal let routineStepResultSet: IndexSortedKeySet<RoutineStepResult>
    
    internal init(
        hedeSchedulerSet: IndexSortedKeySet<HedeScheduler>
        , hedeTaskSet: IndexSortedKeySet<HedeTask>
        , hedeTagSet: IndexSortedKeySet<HedeTag>
        
        , dailyGoalSet: IndexSortedKeySet<DailyGoal>
        , dailyGoalResultSet: IndexGroupedKeySet<DailyGoalResult, Date>
        , dailyGoalListSet: IndexSortedKeySet<DailyGoalList>
        , dailyGoalListSectionSet: IndexSortedKeySet<DailyGoalListSection>
        , routineSet: IndexSortedKeySet<Routine>
        , routineStepSet: IndexSortedKeySet<RoutineStep>
        , routineResultSet: IndexSortedKeySet<RoutineResult>
        , routineStepResultSet: IndexSortedKeySet<RoutineStepResult>
    ) {
        self.hedeSchedulerSet = hedeSchedulerSet
        self.hedeTaskSet = hedeTaskSet
        self.hedeTagSet = hedeTagSet
        
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
            hedeSchedulerSet: IndexSortedKeySet<HedeScheduler>()
            , hedeTaskSet: IndexSortedKeySet<HedeTask>()
            , hedeTagSet: IndexSortedKeySet<HedeTag>()
            
            , dailyGoalSet: IndexSortedKeySet<DailyGoal>()
            , dailyGoalResultSet: IndexGroupedKeySet<DailyGoalResult, Date>()
            , dailyGoalListSet: IndexSortedKeySet<DailyGoalList>()
            , dailyGoalListSectionSet: IndexSortedKeySet<DailyGoalListSection>()
            , routineSet: IndexSortedKeySet<Routine>()
            , routineStepSet: IndexSortedKeySet<RoutineStep>()
            , routineResultSet: IndexSortedKeySet<RoutineResult>()
            , routineStepResultSet: IndexSortedKeySet<RoutineStepResult>()
        )
    }
    
    internal convenience init(
        _ basis: MutableBasis
    ) {
        self.init(
            hedeSchedulerSet: basis.hedeSchedulerSet
            , hedeTaskSet: basis.hedeTaskSet
            , hedeTagSet: basis.hedeTagSet
            
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
    var hedeSchedulerSet: IndexSortedKeySet<HedeScheduler>
    var hedeTaskSet: IndexSortedKeySet<HedeTask>
    var hedeTagSet: IndexSortedKeySet<HedeTag>
    
    // Goals
    var dailyGoalSet: IndexSortedKeySet<DailyGoal>
    var dailyGoalResultSet: IndexGroupedKeySet<DailyGoalResult, Date>
    var dailyGoalListSet: IndexSortedKeySet<DailyGoalList>
    var dailyGoalListSectionSet: IndexSortedKeySet<DailyGoalListSection>
    var routineSet: IndexSortedKeySet<Routine>
    var routineStepSet: IndexSortedKeySet<RoutineStep>
    var routineResultSet: IndexSortedKeySet<RoutineResult>
    var routineStepResultSet: IndexSortedKeySet<RoutineStepResult>
    

    init(
        hedeSchedulerSet: IndexSortedKeySet<HedeScheduler>
        , hedeTaskSet: IndexSortedKeySet<HedeTask>
        , hedeTagSet: IndexSortedKeySet<HedeTag>
        
        , dailyGoalSet: IndexSortedKeySet<DailyGoal>
        , dailyGoalResultSet: IndexGroupedKeySet<DailyGoalResult, Date>
        , dailyGoalListSet: IndexSortedKeySet<DailyGoalList>
        , dailyGoalListSectionSet: IndexSortedKeySet<DailyGoalListSection>
        , routineSet: IndexSortedKeySet<Routine>
        , routineStepSet: IndexSortedKeySet<RoutineStep>
        , routineResultSet: IndexSortedKeySet<RoutineResult>
        , routineStepResultSet: IndexSortedKeySet<RoutineStepResult>
    ) {
        self.hedeSchedulerSet = hedeSchedulerSet
        self.hedeTaskSet = hedeTaskSet
        self.hedeTagSet = hedeTagSet
        
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
            hedeSchedulerSet: basis.hedeSchedulerSet
            , hedeTaskSet: basis.hedeTaskSet
            , hedeTagSet: basis.hedeTagSet
            
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
